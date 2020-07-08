resource "aws_ecs_service" "environment" {
  name    = "${var.servicename}-ecs-svc"
  cluster = var.clustername
  task_definition = "${var.task_definition_family}:${max(
    var.task_definition_revision,
    var.current_task_definition_version,
  )}"
  desired_count                      = var.service_desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
}

