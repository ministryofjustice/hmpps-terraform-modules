#-------------------------------------------------------------
### Iam Templates
#-------------------------------------------------------------

data "template_file" "create_bastion_ec2_role" {
  template = "${file("${path.module}/${local.role_policy_file}")}"

  vars {
    s3-config-bucket = "${var.remote_state_bucket_name}"
    logging-bucket = "${data.terraform_remote_state.vpc.s3_lb_logs_bucket}"
  }
}

module "create_bastion_app_role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${var.short_environment_identifier}-${var.app_name}"
  policyfile = "${local.policy_file}"
}


module "create_bastion_instance_profile" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules/iam/instance_profile"
  role = "${module.create_bastion_app_role.iamrole_name}"
}


module "create_bastion_iam_app_policy" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.create_bastion_ec2_role.rendered}"
  rolename   = "${module.create_bastion_app_role.iamrole_name}"
}
