#-------------------------------------------------------------
### Security groups
#-------------------------------------------------------------
resource "aws_security_group" "monitoring_sg" {
  name        = "${var.environment_identifier}-monitoring-sg"
  description = "security group for ${var.environment_identifier}-monitoring"
  vpc_id      = "${var.terraform_remote_state_vpc["vpc_id"]}"

  ingress {
    from_port = "2514"
    protocol = "tcp"
    to_port = 2514
    description = "${var.environment_identifier}-rsyslog-tcp"
    cidr_blocks = ["${var.terraform_remote_state_vpc["vpc_cidr"]}"]
  }

  ingress {
    from_port = "2514"
    protocol = "udp"
    to_port = 2514
    description = "${var.environment_identifier}-rsyslog-tcp"
    cidr_blocks = ["${var.terraform_remote_state_vpc["vpc_cidr"]}"]
  }

  ingress {
    from_port = "5000"
    to_port   = "5000"
    protocol  = "tcp"
    description = "${var.environment_identifier}-logstash-tcp"
    cidr_blocks = ["${var.terraform_remote_state_vpc["vpc_cidr"]}"]
  }

  ingress {
    from_port = "5000"
    to_port   = "5000"
    protocol  = "udp"
    description = "${var.environment_identifier}-logstash-udp"
    cidr_blocks = ["${var.terraform_remote_state_vpc["vpc_cidr"]}"]
  }

  ingress {
    from_port = "5601"
    to_port   = "5601"
    protocol  = "tcp"
    security_groups = [
      "${var.terraform_remote_state_vpc["vpc_sg_id"]}"
    ]
    description = "${var.environment_identifier}-kibana"
    cidr_blocks = ["${var.terraform_remote_state_vpc["vpc_cidr"]}"]
  }

  ingress {
    from_port = "9200"
    to_port   = "9200"
    protocol  = "tcp"
    description = "${var.environment_identifier}-elasticsearch-http"
    cidr_blocks = ["${var.terraform_remote_state_vpc["vpc_cidr"]}"]
  }

  ingress {
    from_port = "9300"
    to_port   = "9300"
    protocol  = "tcp"
    description = "${var.environment_identifier}-elasticsearch-https"
    cidr_blocks = ["${var.terraform_remote_state_vpc["vpc_cidr"]}"]
  }

  ingress {
    from_port = "9600"
    to_port   = "9600"
    protocol  = "tcp"
    description = "${var.environment_identifier}-logstash"
    cidr_blocks = ["${var.terraform_remote_state_vpc["vpc_cidr"]}"]
  }

  #Allow traffic from self to self
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
    description = "all traffic from self to self"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
    description = "all traffic to self from self"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    description = "all traffic out"
  }

  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-monitoring-sg"))}"
}

resource "aws_security_group" "monitoring_elb_sg" {
  name        = "${var.environment_identifier}-monitoring-elb-sg"
  description = "security group for ${var.environment_identifier}-monitoring-elb"
  vpc_id      = "${var.terraform_remote_state_vpc["vpc_id"]}"

  ingress {
    from_port = "443"
    protocol = "tcp"
    to_port = "443"
    cidr_blocks = ["${var.allowed_ssh_cidr}"]
    description = "Https kibana traffic"
  }

  egress {
    from_port = "5601"
    protocol = "tcp"
    to_port = "5601"
    security_groups = ["${aws_security_group.monitoring_sg.id}"]
  }
}