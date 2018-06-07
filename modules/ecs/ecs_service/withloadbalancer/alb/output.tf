output "ecs_service_id" {
  value = "${aws_ecs_service.environment.id}"
}

output "ecs_service_name" {
  value = "${aws_ecs_service.environment.name}"
}

output "ecs_service_cluster" {
  value = "${aws_ecs_service.environment.cluster}"
}
