#-------------------------------------------------------------
### Iam Templates
#-------------------------------------------------------------

data "template_file" "create_elasticsearch_instance_role" {
  template = "${file("${var.role_policy_file}")}"

  vars {
    ingestion_role_arn = "${module.create_elasticsearch_app_role.iamrole_arn}"
    s3-config-bucket = "${var.terraform_remote_state_vpc["s3-config-bucket"]}"
  }
}

module "create_elasticsearch_app_role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${var.environment_identifier}-${var.app_name}-elasticsearch"
  policyfile = "${local.policy_file}"
}

module "create_elasticsearch_iam_instance_profile" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//instance_profile"
  role   = "${module.create_elasticsearch_app_role.iamrole_name}"
}

module "create_elasticsearch_iam_app_policy" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.create_elasticsearch_instance_role.rendered}"
  rolename   = "${module.create_elasticsearch_app_role.iamrole_name}"
}
