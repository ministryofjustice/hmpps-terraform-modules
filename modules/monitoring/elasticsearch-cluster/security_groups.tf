#-------------------------------------------------------------
### Security groups
#-------------------------------------------------------------

resource "aws_security_group" "elasticsearch_client_sg" {
  name        = "${var.environment_identifier}-elasticsearch-sg"
  description = "security group for ${var.environment_identifier}-elasticsearch"
  vpc_id      = "${var.terraform_remote_state_vpc["vpc_id"]}"

  ingress {
    from_port = "9200"
    to_port   = "9200"
    protocol  = "tcp"
    security_groups = ["${var.terraform_remote_state_vpc["vpc_sg_id"]}"]
    description = "${var.environment_identifier}-es-http-traffic"
  }

  ingress {
    from_port = "9300"
    to_port   = "9300"
    protocol  = "tcp"
    security_groups = ["${var.terraform_remote_state_vpc["vpc_sg_id"]}"]
    description = "${var.environment_identifier}-es-https-traffic"
  }

  #Allow traffic from self to self
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true

  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
  }

  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-elasticsearch-sg"))}"
}