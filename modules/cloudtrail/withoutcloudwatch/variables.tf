variable "s3_bucket_name" {
}

variable "globalevents" {
}

variable "cloudtrailname" {
}

variable "multiregion" {
}

variable "tags" {
  type = map(string)
}

variable "enable_logging" {
  default = true
}

