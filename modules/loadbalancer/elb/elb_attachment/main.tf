resource "aws_elb_attachment" "environment" {
  count = var.number_of_instances

  elb      = var.elb
  instance = element(var.instances, count.index)
}

