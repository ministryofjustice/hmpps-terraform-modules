variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  default     = false
}

variable "subnet_cidr_block" {}

variable "availability_zone" {}
variable "subnet_name" {}
variable "vpc_id" {}

variable "tags" {
  type = "map"
}
