#-------------------------------------------------------------
### Security groups
#-------------------------------------------------------------

resource "aws_security_group" "elasticsearch_client_sg" {
  name        = "${var.environment_identifier}-elasticsearch-sg"
  description = "security group for ${var.environment_identifier}-elasticsearch"
  vpc_id      = "${var.terraform_remote_state_vpc["vpc_id"]}"

  tags = "${merge(var.terraform_remote_state_vpc["tags"], map("Name", "${var.environment_identifier}-elasticsearch-sg"))}"
}

resource "aws_security_group_rule" "elasticsearch_client_sg_es_http_in" {
  from_port = 9200
  protocol = "tcp"
  security_group_id = "${aws_security_group.elasticsearch_client_sg.id}"
  to_port = 9200
  type = "ingress"
  description = "${var.environment_identifier}-es-http-traffic"
}

resource "aws_security_group_rule" "elasticsearch_client_sg_es_https_in" {
  from_port = 9300
  protocol = "tcp"
  security_group_id = "${aws_security_group.elasticsearch_client_sg.id}"
  to_port = 9300
  type = "ingress"
  description = "${var.environment_identifier}-es-http-traffic"
}

resource "aws_security_group_rule" "elasticsearch_client_sg_es_self_in" {
  from_port = 0
  protocol = -1
  security_group_id = "${aws_security_group.elasticsearch_client_sg.id}"
  to_port = 0
  type = "ingress"
  self = true
}

resource "aws_security_group_rule" "elasticsearch_client_sg_es_self_out" {
  from_port = 0
  protocol = -1
  security_group_id = "${aws_security_group.elasticsearch_client_sg.id}"
  to_port = 0
  type = "egress"
  self = true
}

resource "aws_security_group_rule" "elasticsearch_client_sg_es_world_out" {
  from_port = 0
  protocol = -1
  security_group_id = "${aws_security_group.elasticsearch_client_sg.id}"
  to_port = 0
  type = "egress"
}
