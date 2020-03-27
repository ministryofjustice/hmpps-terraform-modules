#-------------------------------------------------------------
### Getting the current running account id
#-------------------------------------------------------------
data "aws_caller_identity" "current" {}


locals {
  account_id     = "${data.aws_caller_identity.current.account_id}"
  assume_role    = "${var.environment_name}-auto-start-role"
  event_role     = "${var.environment_name}-event-role"
  calendar_name  = "${var.environment_name}-calendar"
  start_doc_arn  = "${aws_ssm_document.start.arn}"
  stop_doc_arn   = "${aws_ssm_document.stop.arn}"
}
