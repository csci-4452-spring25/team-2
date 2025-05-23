provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "minecraft_server" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  security_groups        = [aws_security_group.Minecraft_Security.name]
  associate_public_ip_address = true
  iam_instance_profile   = aws_iam_instance_profile.minecraft_profile.name

  user_data = templatefile("${path.module}/user-data.sh", {
    github_token = var.github_token
  })

  tags = {
    Name = "minecraft-llm-server"
  }
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

resource "aws_security_group" "Minecraft_Security"{
  name = "Minecraft_Security"
  description = "Allow Traffic To Minecraft Server"
   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ec2 connection"
  }


  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Minecraft connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

}
