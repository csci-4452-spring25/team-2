provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "minecraft_llm_ec2" {
  name               = "minecraft-llm-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy" "minecraft_llm_policy" {
  name = "minecraft-llm-policy"
  role = aws_iam_role.minecraft_llm_ec2.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query"
        ],
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table_name}"
      },
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = var.openai_secret_arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "minecraft_profile" {
  name = "minecraft-llm-instance-profile"
  role = aws_iam_role.minecraft_llm_ec2.name
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-sg"
  description = "Allow Minecraft port"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft_server" {
  ami                         = var.ec2_ami
  instance_type               = var.minecraft_instance_type
  key_name                    = var.ec2_key_pair
  vpc_security_group_ids      = [aws_security_group.minecraft_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.minecraft_profile.name
  associate_public_ip_address = true

  tags = {
    Name = "Minecraft LLM Server"
  }

  user_data = file("user-data.sh")
}
