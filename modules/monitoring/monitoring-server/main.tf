terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}

locals {
  policy_file                   = "ec2_policy.json"
  role_policy_file              = "policies/ec2_role_policy.json"
  ebs_device_mount_point        = "/dev/xvdb"
  elasticsearch_root_directory  = "/srv"
  docker_registry_url           = "mojdigitalstudio"
  server_dns                    = "monitoring"
}


######
## Monitoring-node internal elb
#####

data "template_file" "monitoring_instance_user_data" {
   template = "${file("${path.module}/user_data/monitoring_user_data.sh")}"

  vars {
    es_home               = "${local.elasticsearch_root_directory}"
    ebs_device            = "${local.ebs_device_mount_point}"
    app_name              = "${var.app_name}"
    env_identifier        = "${var.environment_identifier}"
    short_env_identifier  = "${var.short_environment_identifier}"
    route53_sub_domain    = "${var.route53_sub_domain}"
    private_domain        = "${var.private_zone_name}"
    account_id            = "${var.account_id}"
    internal_domain       = "${var.private_zone_name}"
    version               = "${var.docker_image_tag}"
    aws_cluster           = "${var.elasticsearch_cluster_name}"
    registry_url          = "${local.docker_registry_url}"
  }
}

resource "aws_elb" "monitoring_elb" {

  listener {
    instance_port = "5601"
    instance_protocol = "http"
    lb_port = "443"
    lb_protocol = "https"
    ssl_certificate_id = "${var.public_ssl_arn}"

  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 30
    target              = "TCP:5601"
    interval            = 60
  }

  name = "${var.short_environment_identifier}-${var.app_name}-elb"

  subnets = [
    "${var.public_subnet_ids}"
  ]

  security_groups = ["${aws_security_group.monitoring_elb_sg.id}"]

  tags = "${merge(
    var.tags,
    map("Name", "${var.short_environment_identifier}-${var.app_name}-elb"))
  }"
}

module "create_monitoring_instance" {
  source                      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ec2"
  app_name                    = "${var.environment_identifier}-${var.app_name}-node"
  ami_id                      = "${var.amazon_ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_ids[0]}"
  iam_instance_profile        = "${module.create_monitoring_instance_profile.iam_instance_name}"
  associate_public_ip_address = false
  monitoring                  = true
  user_data                   = "${data.template_file.monitoring_instance_user_data.rendered}"
  CreateSnapshot              = true
  tags                        = "${var.tags}"
  key_name                    = "${var.ssh_deployer_key}"

  vpc_security_group_ids = [
    "sg-01e37db318a75d51a",
    "${var.elasticsearch_cluster_sg_client_id}",
    "${aws_security_group.monitoring_sg.id}"
  ]
}

resource "aws_elb_attachment" "monitoring_node_attachment" {
  elb = "${aws_elb.monitoring_elb.id}"
  instance = "${module.create_monitoring_instance.instance_id}"
}

module "create_monitoring_ebs_volume" {
  source            = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ebs//ebs_volume"
  CreateSnapshot    = true
  tags              = "${var.tags}"
  availability_zone = "${var.availability_zones[0]}"
  volume_size       = "${var.ebs_device_volume_size}"
  encrypted         = true
  app_name          = "${var.environment_identifier}-${var.app_name}-monitoring-volume"
}

module "attach_monitoring_volume" {
  source      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ebs//ebs_attachment"
  device_name = "/dev/xvdb"
  instance_id = "${module.create_monitoring_instance.instance_id}"
  volume_id   = "${module.create_monitoring_ebs_volume.id}"
}

resource "aws_route53_record" "internal_monitoring_dns" {
  name    = "${local.server_dns}.${var.private_zone_name}"
  type    = "A"
  zone_id = "${var.private_zone_id}"
  ttl     = 300
  records = ["${module.create_monitoring_instance.private_ip}"]
}

resource "aws_route53_record" "external_monitoring_dns" {
  zone_id = "${var.route53_hosted_zone_id}"
  name    = "${local.server_dns}.${var.route53_sub_domain}.${var.route53_domain_private}"
  type    = "A"

  alias {
    evaluate_target_health = false
    name = "${aws_elb.monitoring_elb.dns_name}"
    zone_id = "${aws_elb.monitoring_elb.zone_id}"
  }
}


