variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-west-2"
}

# Amazon Linux 2 AMI
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-0be2609ba883822ec"
    "us-east-2" = "ami-0a0ad6b70e61be944"
    "us-west-1" = "ami-005c06c6de69aee84"
    "us-west-2" = "ami-0e999cbd62129e3b1"
  }
}

variable "availability_zones" {
  default     = "us-west-2c"
  description = "List of availability zones, use AWS CLI to find your "
}

variable "key_name" {
  default     = "mastercard"
  description = "Name of AWS key pair"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "3"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "1"
}

variable "EBS_VOLUME_SIZE" {
  default     = "8"
  description = "Storage size in GB"
}

variable "EBS_VOLUME_TYPE" {
  type = string
  default = "gp2"
  description = "The type of data storage: standard, gp2, io1"
}

variable "EC2_ROOT_VOLUME_SIZE" {
  type = string
  default = "8"
  description = "The volume size for the root volume in GiB"
}

variable "EC2_ROOT_VOLUME_TYPE" {
  type = string
  default = "gp2"
  description = "The type of data storage: standard, gp2, io1"
}