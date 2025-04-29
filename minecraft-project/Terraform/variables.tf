variable "aws_region" {
  default = "us-east-1"
}

variable "ec2_key_pair" {
  description = "EC2 key pair name"
  type        = string
}

variable "minecraft_instance_type" {
  default = "t3.medium"
}

variable "dynamodb_table_name" {
  description = "Name of the existing DynamoDB table"
  type        = string
}

variable "openai_secret_arn" {
  description = "ARN of the OpenAI API key secret in Secrets Manager"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where EC2 will be launched"
  type        = string
}

variable "ec2_ami" {
  description = "AMI ID to use for EC2 instance"
  type        = string
}
