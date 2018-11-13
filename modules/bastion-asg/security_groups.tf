#-------------------------------------------------------------
### Bastion security groups
#-------------------------------------------------------------


### External ELB
resource "aws_security_group_rule" "bastion_external_access" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_elb_security_group.id}"
  to_port = 22
  type = "ingress"

  cidr_blocks = [
    "${data.terraform_remote_state.vpc.ssh_whitelist}"
  ]

  description = "${var.environment_identifier}-vpc-bastion-external-access-ssh-in"
}

resource "aws_security_group_rule" "bastion_elb_to_asg_host" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_elb_security_group.id}"
  to_port = 22
  type = "egress"

  source_security_group_id = "${aws_security_group.bastion_asg_security_group.id}"

  description = "${var.environment_identifier}-vpc-bastion-external-access-ssh-out"
}

resource "aws_security_group" "bastion_elb_security_group" {
  name = "${var.environment_identifier}-bastion-elb-sg"
  description = "${var.environment_identifier}-vpc-bastion-external-access"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = "${
    merge(
      data.terraform_remote_state.vpc.tags,
      map("Name", "${var.environment_identifier}-bastion-elb-sg")
    )
  }"
}

### Internal ASG
resource "aws_security_group_rule" "asg_ssh_in" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_asg_security_group.id}"
  to_port = 22
  type = "ingress"

  description = "${var.environment_identifier}-vpc-asg-elb-access-ssh-in"

  source_security_group_id = "${aws_security_group.bastion_elb_security_group.id}"
}

resource "aws_security_group_rule" "asg_ssh_out" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_asg_security_group.id}"
  to_port = 22
  type = "egress"
  source_security_group_id = "${aws_security_group.bastion_host_sg.id}"

  description = "${var.environment_identifier}-vpc-asg-elb-access-ssh-out"

}

resource "aws_security_group" "bastion_asg_security_group" {
  name = "${var.environment_identifier}-bastion-asg-sg"
  description = "${var.environment_identifier}-vpc-asg-ssh"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = "${
    merge(
      data.terraform_remote_state.vpc.tags,
      map("Name", "${var.environment_identifier}-bastion-asg-sg")
    )
  }"
}

### Bastion host(s) security group
resource "aws_security_group_rule" "bastion_host_ssh_in" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 22
  type = "ingress"
  source_security_group_id = "${aws_security_group.bastion_asg_security_group.id}"

  description = "${var.environment_identifier}-vpc-bastion-host-ssh-in"
}

resource "aws_security_group_rule" "bastion_host_self_in" {
  from_port = 0
  protocol = -1
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 0
  type = "ingress"
  self = true

  description = "${var.environment_identifier}-vpc-bastion-host-self-all-in"
}

resource "aws_security_group_rule" "bastion_host_self_out" {
  from_port = 0
  protocol = -1
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 0
  type = "egress"
  self = true

  description = "${var.environment_identifier}-vpc-bastion-host-self-all-out"
}

resource "aws_security_group_rule" "bastion_host_world_out_http" {
  from_port = 80
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 80
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description = "${var.environment_identifier}-vpc-bastion-host-http-out"
}

resource "aws_security_group_rule" "bastion_host_world_out_https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 443
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description = "${var.environment_identifier}-vpc-bastion-host-https-out"
}

resource "aws_security_group_rule" "bastion_vpc_out_ssh" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 22
  type = "egress"
  source_security_group_id = "${aws_security_group.bastion_client_security_group.id}"
  description = "${var.environment_identifier}-vpc-bastion-host-ssh-out"
}

resource "aws_security_group_rule" "bastion_vpc_out_logstash_udp" {
  from_port = 2514
  protocol = "udp"
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 2514
  type = "egress"
  cidr_blocks = [
    "${data.terraform_remote_state.vpc.vpc_cidr}"
  ]
  description = "${var.environment_identifier}-vpc-bastion-host-logstash-udp-out"
}

resource "aws_security_group_rule" "bastion_vpc_out_logstash_tcp" {
  from_port = 2514
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 2514
  type = "egress"
  cidr_blocks = [
    "${data.terraform_remote_state.vpc.vpc_cidr}"
  ]
  description = "${var.environment_identifier}-vpc-bastion-host-logstash-tcp-out"
}

resource "aws_security_group_rule" "bastion_vpc_out_rsyslog_tcp" {
  from_port = 5000
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 5000
  type = "egress"
  cidr_blocks = [
    "${data.terraform_remote_state.vpc.vpc_cidr}"
  ]
  description = "${var.environment_identifier}-vpc-bastion-host-rsyslog-tcp-out"
}

resource "aws_security_group_rule" "bastion_vpc_out_elasticsearch_tcp" {
  from_port = 9200
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 9200
  type = "egress"
  cidr_blocks = [
    "${data.terraform_remote_state.vpc.vpc_cidr}"
  ]
  description = "${var.environment_identifier}-vpc-bastion-host-elasticsearch-tcp-out"
}


resource "aws_security_group" "bastion_host_sg" {
  name = "${var.environment_identifier}-bastion-host-sg"
  description = "${var.environment_identifier}-bastion-host-ssh"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = "${
    merge(
      data.terraform_remote_state.vpc.tags,
      map("Name", "${var.environment_identifier}-bastion-host-sg")
    )
  }"
}

### Bastion client SG
resource "aws_security_group_rule" "bastion_client_ssh_in" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_client_security_group.id}"
  to_port = 22
  type = "ingress"
  source_security_group_id = "${aws_security_group.bastion_host_sg.id}"
  description = "${var.environment_identifier}-vpc-bastion-client-ssh-in"
}

resource "aws_security_group" "bastion_client_security_group" {
  name = "${var.environment_identifier}-bastion-client-sg"
  description = "security group for ${var.environment_identifier}-vpc-bastion-internal-access"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = "${
    merge(
        data.terraform_remote_state.vpc.tags,
        map("Name", "${var.environment_identifier}-bastion-client-sg")
      )
    }"
}
