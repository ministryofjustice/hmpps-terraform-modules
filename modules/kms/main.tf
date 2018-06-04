data "aws_caller_identity" "current" {}

data "template_file" "kms_policy" {
  template = "${file("policies/kms-policy.json")}"

  vars {
    accountID = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_kms_key" "kms" {
  description             = "AWS KMS key tf-${var.kms_key_name}"
  deletion_window_in_days = "${var.deletion_window_in_days}"
  is_enabled              = "${var.is_enabled}"
  enable_key_rotation     = "${var.enable_key_rotation}"
  policy                  = "${data.template_file.kms_policy.rendered}"

  tags {
    Name          = "tf-${var.kms_key_name}"
    Project       = "${var.project}"
    Environment   = "${var.environment}"
    Business-Unit = "${var.business_unit}"
  }
}

resource "aws_kms_alias" "kms" {
  name          = "alias/tf-${var.kms_key_name}"
  target_key_id = "${aws_kms_key.kms.key_id}"
}
