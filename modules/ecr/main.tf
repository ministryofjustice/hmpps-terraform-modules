# app repository

resource "aws_ecr_repository" "repo" {
  name = "${var.app_name}-ecr-repo"
}

resource "aws_ecr_repository_policy" "repo" {
  repository = "${aws_ecr_repository.repo.name}"
  policy     = "${var.policy}"
  depends_on = ["aws_ecr_repository.repo"]
}
