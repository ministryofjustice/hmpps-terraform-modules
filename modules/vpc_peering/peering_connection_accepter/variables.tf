variable "vpc_peering_connection_id" {}

variable "auto_accept" {}

variable "peering_connection_name" {}

variable "create" {
  description = "Whether to create this resource or not"
}

variable "tags" {
  type = "map"
}
