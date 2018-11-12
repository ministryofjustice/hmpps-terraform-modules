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

resource "aws_security_group_rule" "bastion_elb_to_asg" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_elb_security_group.id}"
  to_port = 22
  type = "egress"

  description = "${var.environment_identifier}-vpc-bastion-external-access-ssh-out"
}

resource "aws_security_group" "bastion_elb_security_group" {
  name        = "${var.environment_identifier}-bastion-elb-sg"
  description = "${var.environment_identifier}-vpc-bastion-external-access"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"


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
  type = "ingress"

  description = "${var.environment_identifier}-vpc-asg-elb-access-ssh-out"

}

resource "aws_security_group" "bastion_asg_security_group" {
  name        = "${var.environment_identifier}-bastion-asg-sg"
  description = "${var.environment_identifier}-vpc-asg-ssh"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

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

  description = "${var.environment_identifier}-vpc-bastion-host-http-out"
}

resource "aws_security_group_rule" "bastion_host_world_out_https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 443
  type = "egress"

  description = "${var.environment_identifier}-vpc-bastion-host-https-out"
}

resource "aws_security_group" "bastion_host_sg" {
  name        = "${var.environment_identifier}-bastion-host-sg"
  description = "${var.environment_identifier}-bastion-host-ssh"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = "${
    merge(
      data.terraform_remote_state.vpc.tags,
      map("Name", "${var.environment_identifier}-bastion-host-sg")
    )
  }"
}

resource "aws_security_group_rule" "bastion_client_ssh_in" {
  from_port = 22
  protocol = ""
  security_group_id = "${aws_security_group.bastion_host_sg.id}"
  to_port = 22
  type = "ingress"

  description = "${var.environment_identifier}-vpc-bastion-client-ssh-in"
}

resource "aws_security_group" "bastion_client_security_group" {
  name        = "${var.environment_identifier}-bastion-client-sg"
  description = "security group for ${var.environment_identifier}-vpc-bastion-internal-access"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = "${
    merge(
        data.terraform_remote_state.vpc.tags,
        map("Name", "${var.environment_identifier}-bastion-client-sg")
      )
    }"
}
