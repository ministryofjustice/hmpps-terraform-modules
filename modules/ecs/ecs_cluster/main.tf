resource "aws_ecs_cluster" "environment" {
  name = "${var.cluster_name}-ecs-cluster"
}
