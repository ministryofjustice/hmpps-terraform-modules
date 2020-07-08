resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  encrypted         = var.encrypted

  tags = merge(
    var.tags,
    {
      "Name" = var.app_name
    },
    {
      "CreateSnapshot" = var.CreateSnapshot
    },
  )
}

