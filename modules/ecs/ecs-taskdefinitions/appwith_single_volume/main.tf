resource "aws_ecs_task_definition" "environment" {
  family                = "${var.app_name}-task-definition"
  container_definitions = var.container_definitions

  volume {
    name      = "log"
    host_path = "/var/log/${var.container_name}"
  }

  volume {
    name      = var.data_volume_name
    host_path = var.data_volume_host_path
  }
}

