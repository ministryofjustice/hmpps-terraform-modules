//#-------------------------------------------------------------
//### Getting the latest amazon ami
//#-------------------------------------------------------------
//data "aws_ami" "amazon_ami" {
//  most_recent = true
//
//  filter {
//    name   = "name"
//    values = ["HMPPS Base CentOS master *"]
//  }
//
//  filter {
//    name   = "architecture"
//    values = ["x86_64"]
//  }
//
//  filter {
//    name   = "virtualization-type"
//    values = ["hvm"]
//  }
//
//  filter {
//    name = "root-device-type"
//    values = ["ebs"]
//  }
//}
//
//data "template_file" "bastion_user_data" {
//  template = "${file("user_data/bastion_user_data.sh")}"
//
//  vars {
//    app_name              = "${var.app_name}"
//    env_identifier        = "${var.environment_identifier}"
//    short_env_identifier  = "${var.short_environment_identifier}"
//    route53_sub_domain    = "${var.route53_sub_domain}"
//    private_domain        = "${data.terraform_remote_state.vpc.private_zone_name}"
//    account_id            = "${data.terraform_remote_state.vpc.account_id}"
//    internal_domain       = "${data.terraform_remote_state.vpc.private_zone_name}"
//    bastion_inventory     = "${var.bastion_inventory}"
//  }
//}
//
//## Create asg
//
//resource "aws_autoscaling_group" "bastion_asg" {
//  max_size = 1
//  min_size = 1
//
//  availability_zones = [
//    "${data.terraform_remote_state.vpc.}"
//  ]
//  launch_configuration = "${aws_launch_configuration.bastion_lc}"
//
//  load_balancers = [
//    "${aws_elb.bastion_elb.id}"
//  ]
//
//}
//
//resource "aws_launch_configuration" "bastion_lc" {
//  image_id = "${data.aws_ami.amazon_ami.id}"
//  instance_type = "${var.instance_type}"
//  associate_public_ip_address = false
//  enable_monitoring = true
//  security_groups = [
//    "${aws_security_group.bastion_elb_security_group.id}",
//    "${aws_security_group.bastion_asg_security_group.id}",
//    "${var.vpc_sg_outbound_id}"
//  ]
//
//  user_data = "${data.template_file.bastion_user_data}"
//
//  key_name = "${var.ssh_deployer_key}"
//
//  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-${var.app_name}-lc"))}"
//}
//
//
//
//resource "aws_elb" "bastion_elb" {
//  "listener" {
//    instance_port = 22
//    instance_protocol = "tcp"
//    lb_port = 0
//    lb_protocol = "tcp"
//  }
//
//  security_groups = [
//    "${aws_security_group.bastion_client_security_group.id}",
//    "${aws_security_group.bastion_elb_security_group.id}"
//  ]
//
//  availability_zones = []
//
//  internal = false
//}
//
//resource "aws_route53_record" "bastion_dns_entry" {
//  zone_id = "${var.route53_hosted_zone_id}"
//  name    = "${var.app_name}.${var.route53_sub_domain}.${var.route53_domain_private}"
//  type    = "A"
//  ttl     = "300"
//  records = ["${aws_instance.bastion.public_ip}"]
//}
//
//resource "aws_route53_record" "bastion_dns_alias" {
//  zone_id = "${var.route53_hosted_zone_id}"
//  name    = "jump.${var.route53_sub_domain}.${var.route53_domain_private}"
//  type    = "A"
//  ttl     = "300"
//  records = ["${aws_instance.bastion.public_ip}"]
//}
