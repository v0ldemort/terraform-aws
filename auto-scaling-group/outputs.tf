output "security_group" {
  value = aws_security_group.default.id
}

output "launch_configuration" {
  value = aws_launch_configuration.mastercard-lc.id
}

output "asg_name" {
  value = aws_autoscaling_group.mastercard-asg.id
}

output "elb_name" {
  value = aws_elb.mastercard-elb.dns_name
}
