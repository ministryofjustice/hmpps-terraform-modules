variable "cluster_name" {}

variable "tags" {
  type = "map"

  default = {
    name = "ecs-cluster"
  }
}
