resource "aws_vpc" "environment" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${merge(var.tags, map("Name", "${var.vpc_name}-vpc"))}"
}

resource "aws_vpc_dhcp_options" "environment" {
  domain_name_servers = ["${var.vpc_dns_hosts}"]
  domain_name         = "${var.route53_domain_private}"
  tags                = "${merge(var.tags, map("Name", "tf-${var.vpc_name}-dhcp-options"))}"
}

resource "aws_vpc_dhcp_options_association" "environment" {
  vpc_id          = "${aws_vpc.environment.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.environment.id}"
}
