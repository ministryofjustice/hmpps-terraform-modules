resource "aws_ecs_cluster" "environment" {
  name = "tf-${var.cluster_name}-ecs-cluster"
}
