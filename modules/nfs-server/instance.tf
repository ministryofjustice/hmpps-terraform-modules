#-------------------------------------------------------------
### Create instance and user data
#-------------------------------------------------------------
module "create-ec2-instance" {
  source                      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ec2_no_replace_instance"
  app_name                    = "${var.environment_identifier}-${local.app_name}"
  ami_id                      = "${data.aws_ami.amazon_ami.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.private_subnet_ids[1]}"
  iam_instance_profile        = "${module.create-iam-instance-profile.iam_instance_name}"
  associate_public_ip_address = false
  monitoring                  = true
  user_data                   = "${data.template_file.nfs_user_data.rendered}"
  CreateSnapshot              = true
  tags                        = "${var.tags}"
  key_name                    = "${data.terraform_remote_state.vpc.ssh_deployer_key}"

  vpc_security_group_ids = "${concat(
        var.bastion_origin_sgs,
        list(data.terraform_remote_state.monitoring.monitoring_server_client_sg_id),
        list(aws_security_group.nfs_sg.id),
        list(aws_security_group.nfs_client_sg.id)
      )
    }"
}

data "template_file" "nfs_user_data" {
  template = "${file("${path.module}/user_data/user_data.sh")}"

  vars {
    // Variables Below are for bootstrapping
    app_name              = "${local.app_name}"
    env_identifier        = "${var.environment_identifier}"
    short_env_identifier  = "${var.short_environment_identifier}"
    route53_sub_domain    = "${var.route53_sub_domain}"
    private_domain        = "${data.terraform_remote_state.vpc.private_zone_name}"
    account_id            = "${data.terraform_remote_state.vpc.vpc_account_id}"
    internal_domain       = "${data.terraform_remote_state.vpc.private_zone_name}"
    bastion_inventory     = "${var.bastion_inventory}"
    monitoring_server_url = "${data.terraform_remote_state.monitoring.monitoring_server_internal_url}"

    // LVM data
    device_list           = "'${join("', '", local.device_list)}'"
    device_size           = "${var.nfs_volume_size}"
    device_count          = "${var.volume_count}"
    mount_point           = "${local.mount_point}"
    volume_group_name     = "${local.volume_group_name}"
    logical_volume_name   = "${local.logical_volume_name}"

    allowed_ip_ranges     = "'${join("', '", var.private-cidr)}'"
  }
}