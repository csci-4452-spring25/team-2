provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "minecraft_server" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  # key_name      = var.ec2_key_name

  user_data = file("user-data.sh")

  tags = {
    Name = "minecraft-llm-server"
  }

  iam_instance_profile = aws_iam_instance_profile.minecraft_profile.name
  associate_public_ip_address = true
}

resource "aws_iam_role" "minecraft_role" {
  name = "minecraft-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  role       = aws_iam_role.minecraft_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_instance_profile" "minecraft_profile" {
  name = "minecraft-instance-profile"
  role = aws_iam_role.minecraft_role.name
}
