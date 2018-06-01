# app repository

resource "aws_ecr_repository" "repo" {
  count = "${length(var.app_name)}"
  name  = "tf-${var.region}-terraform-${var.business_unit}-${var.project}-${var.environment}-${element(var.app_name,count.index)}-ecr"
}

resource "aws_ecr_repository_policy" "repo" {
  count      = "${length(var.app_name)}"
  repository = "${element(aws_ecr_repository.repo.*.name,count.index)}"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.role_arn}"
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
  }
EOF

  depends_on = ["aws_ecr_repository.repo"]
}
