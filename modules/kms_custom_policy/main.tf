resource "aws_kms_key" "kms" {
  description             = "AWS KMS key ${var.kms_key_name}-kms-key"
  deletion_window_in_days = var.deletion_window_in_days
  is_enabled              = var.is_enabled
  enable_key_rotation     = var.enable_key_rotation
  policy                  = var.policy
  tags = merge(
    var.tags,
    {
      "Name" = "${var.kms_key_name}-kms-key"
    },
  )
}

resource "aws_kms_alias" "kms" {
  name          = "alias/${var.kms_key_name}-kms-key"
  target_key_id = aws_kms_key.kms.key_id
}

