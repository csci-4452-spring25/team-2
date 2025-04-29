variable "aws_region" {
  default = "us-west-2"
}

variable "ec2_ami" {
  description = "AMI ID to use"
  type        = string
}

variable "ec2_instance_type" {
  default = "t3.small"
}

variable "ec2_key_name" {
  description = "EC2 SSH key name"
  type        = string
}

variable "github_token" {
  type      = string
  sensitive = true
}