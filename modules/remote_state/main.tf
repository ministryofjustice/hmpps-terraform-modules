resource "aws_iam_role_policy" "remote_state" {
  name = "tf_${var.business_unit}_${var.project}_${var.environment}_remote_state_policy"
  role = "terraform"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.remote_state.arn}"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "remote_state" {
  bucket = "tf-${var.region}-terraform-${var.business_unit}-${var.project}-${var.environment}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
