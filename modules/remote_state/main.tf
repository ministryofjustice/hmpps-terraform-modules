resource "aws_iam_role_policy" "remote_state" {
  name = "${var.remote_state_bucket_name}-policy"
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
  bucket = "${var.remote_state_bucket_name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
