variable "table_name" {
  description = "resource label or name"
}

variable "hash_key" {
}

variable "read_capacity" {
  default = "10"
}

variable "write_capacity" {
  default = "5"
}

variable "tags" {
  type = map(string)
}

