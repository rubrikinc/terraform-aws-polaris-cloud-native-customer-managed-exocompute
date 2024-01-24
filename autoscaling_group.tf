resource "aws_autoscaling_group" "cluster" {
  name                = "${var.name_prefix}-autoscaling-group-${data.aws_region.current.name}"
  min_size            = 1
  max_size            = var.autoscaling_max_size
  desired_capacity    = 1
  vpc_zone_identifier = [
      aws_subnet.rsc_exocompute_subnet_1.id, 
      aws_subnet.rsc_exocompute_subnet_2.id
  ]

  launch_template {
    id      = aws_launch_template.worker.id
    version = "$Latest"
  }
}