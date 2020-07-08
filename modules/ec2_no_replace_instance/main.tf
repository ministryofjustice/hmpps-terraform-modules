resource "aws_instance" "instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name

  tags = merge(
    var.tags,
    {
      "Name" = var.app_name
    },
    {
      "CreateSnapshot" = var.CreateSnapshot
    },
  )

  monitoring = var.monitoring
  user_data  = var.user_data

  root_block_device {
    volume_size = var.root_device_size
  }

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
    ]
  }
}

