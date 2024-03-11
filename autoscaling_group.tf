resource "aws_autoscaling_group" "cluster" {
  name                = var.aws_autoscaling_group_name
  min_size            = 1
  max_size            = var.autoscaling_max_size
  desired_capacity    = 1
  vpc_zone_identifier = [
      var.rsc_exocompute_subnet_1_id, 
      var.rsc_exocompute_subnet_2_id
  ]

  launch_template {
    id      = aws_launch_template.worker.id
    version = "$Latest"
  }
}