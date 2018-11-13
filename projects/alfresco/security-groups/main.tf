####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################

####################################################
# Locals
####################################################
locals {
  common_name        = "${var.environment_identifier}-${var.alfresco_app_name}"
  vpc_id             = "${var.vpc_id}"
  allowed_cidr_block = "${var.allowed_cidr_block}"
  tags               = "${var.tags}"

  public_cidr_block = ["${var.public_cidr_block}"]

  private_cidr_block = ["${var.private_cidr_block}"]

  db_cidr_block       = ["${var.db_cidr_block}"]
  internal_lb_sg_id   = "${var.sg_map_ids["internal_lb_sg_id"]}"
  internal_inst_sg_id = "${var.sg_map_ids["internal_inst_sg_id"]}"
  db_sg_id            = "${var.sg_map_ids["db_sg_id"]}"
  external_lb_sg_id   = "${var.sg_map_ids["external_lb_sg_id"]}"
  external_inst_sg_id = "${var.sg_map_ids["external_inst_sg_id"]}"
}

#######################################
# SECURITY GROUPS
#######################################
#-------------------------------------------------------------
### external lb sg
#-------------------------------------------------------------

resource "aws_security_group_rule" "external_lb_ingress_http" {
  security_group_id = "${local.external_lb_sg_id}"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  type              = "ingress"
  description       = "${local.common_name}-lb-external-sg-http"

  cidr_blocks = [
    "${local.allowed_cidr_block}",
  ]
}

resource "aws_security_group_rule" "external_lb_ingress_https" {
  security_group_id = "${local.external_lb_sg_id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  description       = "${local.common_name}-lb-external-sg-https"

  cidr_blocks = [
    "${local.allowed_cidr_block}",
  ]
}

resource "aws_security_group_rule" "external_lb_egress_http" {
  security_group_id        = "${local.external_lb_sg_id}"
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-instance-internal-http"
}

resource "aws_security_group_rule" "external_lb_egress_https" {
  security_group_id        = "${local.external_lb_sg_id}"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-instance-internal-https"
}

#-------------------------------------------------------------
### external instance sg
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_inst_sg_ingress_self" {
  security_group_id = "${local.external_inst_sg_id}"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
}

resource "aws_security_group_rule" "external_inst_sg_ingress_self" {
  security_group_id = "${local.external_inst_sg_id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
}

resource "aws_security_group_rule" "external_inst_ingress_http" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${local.external_lb_sg_id}"
  description              = "${local.common_name}-instance-external-ingress-http"
}

resource "aws_security_group_rule" "external_inst_ingress_https" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${local.external_lb_sg_id}"
  description              = "${local.common_name}-instance-external-ingress-https"
}

resource "aws_security_group_rule" "external_inst_egress_http" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-external-egress-http"
}

resource "aws_security_group_rule" "external_inst_egress_https" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-external-egress-https"
}

#-------------------------------------------------------------
### internal lb sg
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_lb_ingress_http" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-lb-ingress-http"
}

resource "aws_security_group_rule" "internal_lb_ingress_https" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-lb-ingress-https"
}

resource "aws_security_group_rule" "internal_lb_sg_egress_alb_backend_port" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = "${var.alb_backend_port}"
  to_port                  = "${var.alb_backend_port}"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "${local.common_name}"
}

#-------------------------------------------------------------
### internal instance sg
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_inst_sg_ingress_self" {
  security_group_id = "${local.internal_inst_sg_id}"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
}

resource "aws_security_group_rule" "internal_inst_sg_egress_self" {
  security_group_id = "${local.internal_inst_sg_id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
}

resource "aws_security_group_rule" "internal_inst_sg_ingress_alb_backend_port" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "ingress"
  from_port                = "${var.alb_backend_port}"
  to_port                  = "${var.alb_backend_port}"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-internal-sg"
}

resource "aws_security_group_rule" "internal_inst_sg_ingress_alb_http_port" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "ingress"
  from_port                = "${var.alb_http_port}"
  to_port                  = "${var.alb_http_port}"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-internal-sg"
}

resource "aws_security_group_rule" "internal_inst_sg_egress_postgres" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "egress"
  from_port                = "5432"
  to_port                  = "5432"
  protocol                 = "tcp"
  source_security_group_id = "${local.db_sg_id}"
  description              = "${local.common_name}-rds-sg"
}

#-------------------------------------------------------------
### rds sg
#-------------------------------------------------------------
resource "aws_security_group_rule" "rds_sg_egress_postgres" {
  security_group_id        = "${local.db_sg_id}"
  type                     = "ingress"
  from_port                = "5432"
  to_port                  = "5432"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "${local.common_name}-rds-sg"
}
