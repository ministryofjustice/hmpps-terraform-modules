#-------------------------------------------------------------
### Getting the latest amazon ami
#-------------------------------------------------------------
data "aws_ami" "amazon_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["HMPPS Base CentOS master *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}

data "template_file" "bastion_user_data" {
  template = "${file("user_data/bastion_user_data.sh")}"

  vars {
    app_name              = "${var.app_name}"
    env_identifier        = "${var.environment_identifier}"
    short_env_identifier  = "${var.short_environment_identifier}"
    route53_sub_domain    = "${var.route53_sub_domain}"
    private_domain        = "${data.terraform_remote_state.vpc.private_zone_name}"
    account_id            = "${data.terraform_remote_state.vpc.account_id}"
    internal_domain       = "${data.terraform_remote_state.vpc.private_zone_name}"
    bastion_inventory     = "${var.bastion_inventory}"
  }
}

module "bastion_instance_profile" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules/iam/instance_profile"
  role = "${var.environment_identifier}-${var.app_name}"
}

module "bastion_launch_config" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules/launch_configuration/noblockdevice"

  image_id = "${data.aws_ami.amazon_ami.id}"
  instance_type = "${var.instance_type}"
  instance_profile = "${module.bastion_instance_profile.iam_instance_name}"
  key_name = "${data.terraform_remote_state.vpc.ssh_deployer_key}"
  security_groups = [
    "${aws_security_group.bastion_host_sg.id}"
  ]

  user_data = "${data.template_file.bastion_user_data.rendered}"

  launch_configuration_name = "${var.environment_identifier}-vpc-bastion-host-lc"
}

resource "aws_elb" "bastion_external_lb" {
  name            = "${var.short_environment_identifier}-bastion-elb"
  security_groups = [
    "${aws_security_group.bastion_elb_security_group.id}"
  ]
  subnets         = [
    "${data.terraform_remote_state.vpc.public-subnet-az1}",
    "${data.terraform_remote_state.vpc.public-subnet-az2}",
    "${data.terraform_remote_state.vpc.public-subnet-az3}"
  ]
  internal        = false
  tags            = "${
    merge(
      data.terraform_remote_state.vpc.tags,
      map("Name", "${var.short_environment_identifier}-bastion-elb")
    )
  }"

  access_logs {
    bucket        = "${data.terraform_remote_state.vpc.s3_lb_logs_bucket}"
    bucket_prefix = "${var.app_name}"
    interval      = 60
  }

  listener {
    instance_port = 22
    instance_protocol = "tcp"
    lb_port = 22
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    interval = 60
    target = "TCP:22"
    timeout = 30
    unhealthy_threshold = 5
  }
}

module "bastion_asg" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules/autoscaling/group/asg_classic_lb"
  subnet_ids = [
    "${data.terraform_remote_state.vpc.public-subnet-az1}",
    "${data.terraform_remote_state.vpc.public-subnet-az2}",
    "${data.terraform_remote_state.vpc.public-subnet-az3}"
  ]

  asg_min = 1
  asg_max = 2
  asg_desired = 1
  launch_configuration = "${module.bastion_launch_config.launch_id}"
  asg_name = "${var.short_environment_identifier}-bastion-asg"
  load_balancers = [
    "${aws_elb.bastion_external_lb.id}"
  ]
  tags            = "${
    merge(
      data.terraform_remote_state.vpc.tags,
      map("Name", "${var.short_environment_identifier}-bastion-asg")
    )
  }"
}

resource "aws_route53_record" "jumphost_dns_entry" {
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name    = "jumphost.${var.route53_sub_domain}.${var.route53_domain_private}"
  type    = "A"

  alias {
    evaluate_target_health = false
    name = "${aws_elb.bastion_external_lb.dns_name}"
    zone_id = "${aws_elb.bastion_external_lb.zone_id}"
  }
}

resource "aws_route53_record" "bastion_dns_entry" {
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name    = "bastion.${var.route53_sub_domain}.${var.route53_domain_private}"
  type    = "A"

  alias {
    evaluate_target_health = false
    name = "${aws_elb.bastion_external_lb.dns_name}"
    zone_id = "${aws_elb.bastion_external_lb.zone_id}"
  }
}
