#-------------------------------------------------------------
### Create Security Groups
#-------------------------------------------------------------
# https://stackoverflow.com/questions/26187345/iptables-rules-for-nfs-server-and-nfs-client

#-------------------------------------------------------------
### Outbound rules
#-------------------------------------------------------------

resource "aws_security_group_rule" "nfs_sg_outbound_global_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.nfs_sg.id
  to_port           = 80
  type              = "egress"
  description       = "${var.environment_identifier}-${var.app_name}-nfs-sg-global-outbound-http"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nfs_sg_outbound_global_https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.nfs_sg.id
  to_port           = 443
  type              = "egress"
  description       = "${var.environment_identifier}-${var.app_name}-nfs-sg-global-outbound-https"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nfs_sg_vpc_outbound_all_protocols" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nfs_sg.id
  to_port           = 0
  type              = "egress"
  description       = "${var.environment_identifier}-${var.app_name}-nfs-sg-vpc-outbound-all"
  cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
}

resource "aws_security_group" "nfs_sg" {
  name        = "${var.environment_identifier}-${var.app_name}-nfs-sg"
  description = "security group for ${var.environment_identifier}-vpc-nfs"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = merge(
    var.tags,
    { "Name" = "${var.environment_identifier}-${var.app_name}-nfs-sg" },
  )
}

#-------------------------------------------------------------
### Client rules
#-------------------------------------------------------------

resource "aws_security_group_rule" "nfs_client_sg_in" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nfs_client_sg.id
  to_port           = 0
  type              = "ingress"
  description       = "${var.environment_identifier}-${var.app_name}-nfs-client-sg-in"

  source_security_group_id = aws_security_group.nfs_sg.id
}

resource "aws_security_group_rule" "nfs_client_sg_out" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nfs_client_sg.id
  to_port           = 0
  type              = "egress"
  description       = "${var.environment_identifier}-${var.app_name}-nfs-client-sg-in"

  source_security_group_id = aws_security_group.nfs_sg.id
}

resource "aws_security_group_rule" "nfs_client_sg_in_self" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nfs_client_sg.id
  to_port           = 0
  type              = "ingress"
  description       = "${var.environment_identifier}-${var.app_name}-nfs-client-sg-in"
  self              = true
}

resource "aws_security_group_rule" "nfs_client_sg_out_self" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nfs_client_sg.id
  to_port           = 0
  type              = "egress"
  description       = "${var.environment_identifier}-${var.app_name}-nfs-client-sg-in"
  self              = true
}

resource "aws_security_group" "nfs_client_sg" {
  name        = "${var.environment_identifier}-${var.app_name}-nfs-client-sg"
  description = "security group for ${var.environment_identifier}-vpc-nfs-access"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = merge(
    var.tags,
    { "Name" = "${var.environment_identifier}-${var.app_name}-nfs-client-sg" },
  )
}

