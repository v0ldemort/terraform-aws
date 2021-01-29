terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}

locals {
  availability_zones = split(",", var.availability_zones)
}

resource "aws_elb" "mastercard-elb" {
  name = "mastercard-webserver-elb"

  # The same availability zone as our instances
  availability_zones = local.availability_zones
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

resource "aws_autoscaling_policy" "mastercard_scaling_policy" {
  name                   = "asg-scaling-policy"
  adjustment_type        = "ExactCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.mastercard-asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}

resource "aws_autoscaling_group" "mastercard-asg" {
  availability_zones   = local.availability_zones
  name                 = "mastercard-webserver-asg"
  max_size             = var.asg_max
  min_size             = var.asg_min
  desired_capacity     = var.asg_desired
  force_delete         = true
  launch_configuration = aws_launch_configuration.mastercard-lc.name
  load_balancers       = [aws_elb.mastercard-elb.name]

  #vpc_zone_identifier = ["${split(",", var.availability_zones)}"]
  tag {
    key = "Name"
    value = "mastercard-webserver-asg"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "mastercard-lc" {
  name          = "mastercard-webserver-lc"
  image_id      = var.aws_amis[var.aws_region]
  instance_type = var.instance_type

  # Security group
  security_groups = [aws_security_group.default.id]
  user_data       = file("userdata.sh")
  key_name        = var.key_name

  root_block_device {
      volume_size = var.EC2_ROOT_VOLUME_SIZE
      volume_type = var.EC2_ROOT_VOLUME_TYPE
      encrypted   = true
    }

  ebs_block_device {
    device_name           = "/dev/xvdz"
    volume_type           = var.EBS_VOLUME_TYPE
    volume_size           = var.EBS_VOLUME_SIZE
    delete_on_termination = true
    encrypted             = true
    }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "mastercard-webserver-sg"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
