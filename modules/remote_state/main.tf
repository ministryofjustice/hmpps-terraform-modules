resource "aws_iam_role_policy" "remote_state" {
  name = "tf-${var.s3_bucket_name}-remote-state-policy"
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
  bucket = "tf-${var.s3_bucket_name}-remote-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
