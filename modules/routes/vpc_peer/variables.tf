variable "route_table_id" {
  type = list(string)
}

variable "vpc_peer_id" {
  type = string
}

variable "destination_cidr_block" {
  type = string
}

variable "create" {
  description = "Whether to create this resource or not"
  type = bool
}
