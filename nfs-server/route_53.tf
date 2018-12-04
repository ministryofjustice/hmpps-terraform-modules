#-------------------------------------------------------------
### Create Route53 Entries
#-------------------------------------------------------------

resource "aws_route53_record" "internal_dns" {
  name    = "${var.app_name}.${data.terraform_remote_state.vpc.private_zone_name}"
  type    = "A"
  zone_id = "${data.terraform_remote_state.vpc.private_zone_id}"
  ttl     = 300
  records = ["${module.create-ec2-instance.private_ip}"]
}
