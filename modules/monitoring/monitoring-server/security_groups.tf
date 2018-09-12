#-------------------------------------------------------------
### Security groups
#-------------------------------------------------------------

resource "aws_security_group" "monitoring_sg" {
  name = "${var.environment_identifier}-monitoring-sg"
  description = "security group for ${var.environment_identifier}-monitoring"
  vpc_id = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-monitoring-sg"))}"
}

resource "aws_security_group_rule" "bastion_ssh_in" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.monitoring_sg.id}"
  to_port           = 22
  type              = "ingress"
  description       = "Shared Bastion CIDR ssh in"
  cidr_blocks       = ["${var.bastion_origin_cidr}"]
}

resource "aws_security_group_rule" "monitoring_rsyslog_tcp_in" {
  from_port = 2514
  protocol = "tcp"
  to_port = 2514
  description = "${var.environment_identifier}-rsyslog-tcp"
  cidr_blocks = [
    "${var.vpc_cidr}"]
  type = "ingress"
  security_group_id = "${aws_security_group.monitoring_sg.id}"
}

resource "aws_security_group_rule" "monitoring_rsyslog_udp_in" {
  from_port = 2514
  protocol = "udp"
  to_port = 2514
  description = "${var.environment_identifier}-rsyslog-udp"
  cidr_blocks = [
    "${var.vpc_cidr}"]
  type = "ingress"
  security_group_id = "${aws_security_group.monitoring_sg.id}"
}

resource "aws_security_group_rule" "monitoring_logstash_tcp_in" {
  from_port = 5000
  protocol = "tcp"
  to_port = 5000
  description = "${var.environment_identifier}-logstash-tcp"
  cidr_blocks = [
    "${var.vpc_cidr}"]
  type = "ingress"
  security_group_id = "${aws_security_group.monitoring_sg.id}"
}

resource "aws_security_group_rule" "monitoring_logstash_udp_in" {
  from_port = 5000
  protocol = "udp"
  to_port = 5000
  description = "${var.environment_identifier}-logstash-udp"
  cidr_blocks = [
    "${var.vpc_cidr}"]
  type = "ingress"
  security_group_id = "${aws_security_group.monitoring_sg.id}"
}

resource "aws_security_group_rule" "monitoring_kibana_tcp_in" {
  from_port = "5601"
  to_port = "5601"
  protocol = "tcp"
  description = "${var.environment_identifier}-kibana"
  cidr_blocks = [
    "${var.vpc_cidr}"]
  type = "ingress"
  security_group_id = "${aws_security_group.monitoring_sg.id}"
}

resource "aws_security_group_rule" "monitoring_elasticsearch_http_in" {
  from_port = "9200"
  to_port = "9200"
  protocol = "tcp"
  cidr_blocks = ["${var.vpc_cidr}"]
  type = "ingress"
  security_group_id = "${aws_security_group.monitoring_sg.id}"
  description = "${var.environment_identifier}-elasticsearch-http"
}

resource "aws_security_group_rule" "monitoring_elasticsearch_https_in" {
  from_port = "9300"
  to_port = "9300"
  protocol = "tcp"
  cidr_blocks = ["${var.vpc_cidr}"]
  type = "ingress"
  security_group_id = "${aws_security_group.monitoring_sg.id}"
  description = "${var.environment_identifier}-elasticsearch-https"
}

resource "aws_security_group_rule" "monitoring_elasticsearch_logstash_in" {
  from_port = "9600"
  to_port = "9600"
  protocol = "tcp"
  cidr_blocks = [
    "${var.vpc_cidr}"]
  type = "ingress"
  security_group_id = "${aws_security_group.monitoring_sg.id}"
  description = "${var.environment_identifier}-logstash"
}


resource "aws_security_group_rule" "elasticsearch_client_sg_es_self_in" {
  from_port = 0
  protocol = -1
  security_group_id = "${aws_security_group.monitoring_sg.id}"
  to_port = 0
  type = "ingress"
  self = true
}

resource "aws_security_group_rule" "elasticsearch_client_sg_es_self_out" {
  from_port = 0
  protocol = -1
  security_group_id = "${aws_security_group.monitoring_sg.id}"
  to_port = 0
  type = "egress"
  self = true
}

resource "aws_security_group_rule" "elasticsearch_client_sg_es_world_out" {
  from_port = 0
  protocol = -1
  security_group_id = "${aws_security_group.monitoring_sg.id}"
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group" "monitoring_elb_sg" {
  name = "${var.environment_identifier}-monitoring-elb-sg"
  description = "security group for ${var.environment_identifier}-monitoring-elb"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "monitoring_elb_sg_https_in" {
  description       = "Inbound Kibana traffic"
  from_port         = "443"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.monitoring_elb_sg.id}"
  cidr_blocks       = [
    "${var.whitelist_monitoring_ips}"
  ]
  to_port           = "443"
  type              = "ingress"
}

resource "aws_security_group_rule" "monitoring_elb_sg_kibana_out" {
  description               = "Outbound Kibana traffic"
  from_port                 = "5601"
  protocol                  = "tcp"
  security_group_id         = "${aws_security_group.monitoring_elb_sg.id}"
  to_port                   = "5601"
  type                      = "egress"
  source_security_group_id  = "${aws_security_group.monitoring_sg.id}"
}