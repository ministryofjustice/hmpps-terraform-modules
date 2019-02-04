variable "lambda_function_arn" {
  type = "string"
  default = "arn:aws:lambda:eu-west-2:723123699647:function:debugFunction"
}

variable "sns_identifier" {
  type = "string"
  default = "debug"
}
