variable "vpc_peering_connection_id" {
  type = string
}

variable "auto_accept" {
  type = bool
}

variable "peering_connection_name" {
  type = string
}

variable "create" {
  description = "Whether to create this resource or not"
  type = bool
}

variable "tags" {
  type = map(string)
}
