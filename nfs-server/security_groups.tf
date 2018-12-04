#-------------------------------------------------------------
### Create Security Groups
#-------------------------------------------------------------


#-------------------------------------------------------------
### Outbound rules
#-------------------------------------------------------------

resource "aws_security_group_rule" "nfs_sg_outbound_global_http" {
  from_port = 80
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_sg.id}"
  to_port = 80
  type = "egress"
  description = "${var.environment_identifier}-nfs-sg-global-outbound-http"
}

resource "aws_security_group_rule" "nfs_sg_outbound_global_https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_sg.id}"
  to_port = 443
  type = "egress"
  description = "${var.environment_identifier}-nfs-sg-global-outbound-https"
}

resource "aws_security_group_rule" "nfs_sg_vpc_outbound_all_protocols" {
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.nfs_sg.id}"
  to_port =0
  type = "egress"
  description = "${var.environment_identifier}-nfs-sg-vpc-outbound-all"
  cidr_blocks = ["${data.terraform_remote_state.vpc.vpc_cidr}"]
}

resource "aws_security_group" "nfs_sg" {
  name        = "${var.environment_identifier}-nfs-sg"
  description = "security group for ${var.environment_identifier}-vpc-nfs"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-nfs-sg"))}"
}

#-------------------------------------------------------------
### Client rules
#-------------------------------------------------------------

resource "aws_security_group_rule" "nfs_sg_client_nfs_portmapper_tcp_in" {
  from_port = 111
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 111
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-portmapper-tcp-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_portmapper_udp_in" {
  from_port = 111
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 111
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-portmapper-udp-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_portmapper_tcp_out" {
  from_port = 111
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 111
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-portmapper-tcp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_portmapper_udp_out" {
  from_port = 111
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 111
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-portmapper-udp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_tcp_main_in" {
  from_port = 2049
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 2049
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-main-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_udp_main_in" {
  from_port = 2049
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 2049
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-udp-main-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_tcp_main_out" {
  from_port = 2049
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 2049
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-main-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_udp_main_out" {
  from_port = 2049
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 2049
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-udp-main-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_tcp_cluster_health_in" {
  from_port = 32768
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 32768
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-cluster-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_udp_cluster_health_in" {
  from_port = 32768
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 32768
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-udp-cluster-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_tcp_cluster_health_out" {
  from_port = 32768
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 32768
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-cluster-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_udp_cluster_health_out" {
  from_port = 32768
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 32768
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-udp-cluster-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_udp_nfs_ports_in" {
  from_port = 32770
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 32800
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-udp-nfs-ports-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_portmapper_udp_nfs_ports_out" {
  from_port = 32770
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 32800
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-udp-nfs-ports-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_lock_manager_1_in" {
  from_port = 44182
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 44182
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-lock-manager-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_lock_manager_1_out" {
  from_port = 44182
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 44182
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-lock-manager-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_lock_manager_2_in" {
  from_port = 44182
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 44182
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-lock-manager-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_lock_manager_2_out" {
  from_port = 54508
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 54508
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-lock-manager-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group" "nfs_client_sg" {
  name        = "${var.environment_identifier}-nfs-client-sg"
  description = "security group for ${var.environment_identifier}-vpc-nfs-access"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-nfs-client-sg"))}"
}