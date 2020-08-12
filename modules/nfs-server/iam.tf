#-------------------------------------------------------------
### Create policies
#-------------------------------------------------------------
data "template_file" "iam_policy_app" {
  template = file("${path.module}/${var.ec2_role_policy_file}")

  vars = {
    buckets = join(", ", local.bucket_list)
  }
}

module "create-iam-app-role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/iam/role?ref=terraform-0.12"
  rolename   = "${var.environment_identifier}-${local.app_name}-ec2"
  policyfile = var.ec2_policy_file
}

module "create-iam-instance-profile" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/iam/instance_profile?ref=terraform-0.12"
  role   = module.create-iam-app-role.iamrole_name
}

module "create-iam-app-policy" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/iam/rolepolicy?ref=terraform-0.12"
  policyfile = data.template_file.iam_policy_app.rendered
  rolename   = module.create-iam-app-role.iamrole_name
}

