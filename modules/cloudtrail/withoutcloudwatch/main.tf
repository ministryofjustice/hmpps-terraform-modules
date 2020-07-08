resource "aws_cloudtrail" "environment" {
  name                          = "${var.cloudtrailname}-cloudtrail"
  s3_bucket_name                = var.s3_bucket_name
  include_global_service_events = var.globalevents
  is_multi_region_trail         = var.multiregion
  enable_logging                = var.enable_logging
  tags = merge(
    var.tags,
    {
      "Name" = "${var.cloudtrailname}-cloudtrail"
    },
  )
}

