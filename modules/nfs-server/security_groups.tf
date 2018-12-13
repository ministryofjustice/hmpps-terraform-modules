#-------------------------------------------------------------
### Create Security Groups
#-------------------------------------------------------------
# https://stackoverflow.com/questions/26187345/iptables-rules-for-nfs-server-and-nfs-client

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

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nfs_sg_outbound_global_https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_sg.id}"
  to_port = 443
  type = "egress"
  description = "${var.environment_identifier}-nfs-sg-global-outbound-https"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nfs_sg_vpc_outbound_all_protocols" {
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.nfs_sg.id}"
  to_port =0
  type = "egress"
  description = "${var.environment_identifier}-nfs-sg-vpc-outbound-all"
  cidr_blocks = ["${data.terraform_remote_state.vpc.vpc_cidr_block}"]
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

resource "aws_security_group_rule" "nfs_sg_client_nfs_rpc_mountd_tcp_in" {
  from_port = 892
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 892
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-rpc-mountd-tcp-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_rpc_mountd_tcp_out" {
  from_port = 892
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 892
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-rpc-mountd-tcp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_rpc_mountd_udp_in" {
  from_port = 892
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 892
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-rpc-mountd-udp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_rpc_mountd_udp_out" {
  from_port = 892
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 892
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-rpc-mountd-tcp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

//Statd
resource "aws_security_group_rule" "nfs_sg_client_nfs_rpc_statd_tcp_in" {
  from_port = 662
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 662
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-rpc-statd-tcp-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_rpc_statd_tcp_out" {
  from_port = 662
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 662
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-rpc-statd-tcp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_rpc_statd_bound_udp_out" {
  from_port = 2020
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 2020
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-rpc-statd-udp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_rpc_statd_bound_tcp_out" {
  from_port = 2020
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 2020
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-rpc-statd-tcp-out"

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
  type = "egress"
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
  from_port = 54508
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 54508
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

resource "aws_security_group_rule" "nfs_sg_client_nfs_rquoatad_tcp_in" {
  from_port = 875
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 875
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-rquotad-tcp-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_rquoatad_udp_in" {
  from_port = 875
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 875
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-rquotad-udp-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_rquoatad_tcp_out" {
  from_port = 875
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 875
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-rquotad-tcp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_rquoatad_udp_out" {
  from_port = 875
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 875
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-tcp-rquotad-udp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

//Lockd tcp
resource "aws_security_group_rule" "nfs_sg_client_nfs_lockd_tcp_in" {
  from_port = 32803
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 32803
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-lockd-tcp-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_lockd_tcp_out" {
  from_port = 32803
  protocol = "tcp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 32803
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-lockd-tcp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

//Lockd udp
resource "aws_security_group_rule" "nfs_sg_client_nfs_lockd_udp_in" {
  from_port = 32769
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 32769
  type = "ingress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-lockd-udp-in"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group_rule" "nfs_sg_client_nfs_lockd_udp_out" {
  from_port = 32769
  protocol = "udp"
  security_group_id = "${aws_security_group.nfs_client_sg.id}"
  to_port = 32769
  type = "egress"
  description = "${var.environment_identifier}-nfs-client-sg-nfs-lockd-udp-out"

  source_security_group_id = "${aws_security_group.nfs_sg.id}"
}

resource "aws_security_group" "nfs_client_sg" {
  name        = "${var.environment_identifier}-nfs-client-sg"
  description = "security group for ${var.environment_identifier}-vpc-nfs-access"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-nfs-client-sg"))}"
}