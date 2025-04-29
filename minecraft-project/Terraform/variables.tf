variable "aws_region" {
  default = "us-west-2"
}

variable "ec2_ami" {
  description = "ami-05572e392e80aee89"
  type        = string
}

variable "ec2_instance_type" {
  default = "t2.small"
}

variable "ec2_key_name" {
  description = "EC2 SSH key name"
  type        = string
}
