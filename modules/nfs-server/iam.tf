#-------------------------------------------------------------
### Create policies
#-------------------------------------------------------------
data "template_file" "iam_policy_app" {
  template = "${file("${var.ec2_role_policy_file}")}"

  vars {
    s3-config-bucket = "${data.terraform_remote_state.vpc.s3-config-bucket}"
  }
}

module "create-iam-app-role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${var.environment_identifier}-${local.app_name}-ec2"
  policyfile = "${var.ec2_policy_file}"
}

module "create-iam-instance-profile" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//instance_profile"
  role   = "${module.create-iam-app-role.iamrole_name}"
}

module "create-iam-app-policy" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.iam_policy_app.rendered}"
  rolename   = "${module.create-iam-app-role.iamrole_name}"
}

