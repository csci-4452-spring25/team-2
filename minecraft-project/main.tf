provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft_sg"
  description = "Allow Minecraft and LLM traffic"

  ingress {
    description = "Minecraft Server Port"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add more rules for LLM if needed (like 5000 for Flask API)
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft_server" {
  ami           = "ami-xxxxxxxxxxxxxxxxx" # Find the right AMI (e.g., Ubuntu 22.04)
  instance_type = "t3.medium"             # Good starting point, adjust if you need more RAM
  key_name      = "your-ssh-key"
  security_groups = [aws_security_group.minecraft_sg.name]

  tags = {
    Name = "MinecraftLLMServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y openjdk-17-jre-headless
              mkdir /minecraft
              cd /minecraft
              # Download your Minecraft server jar or LLM server setup here
              EOF
}

output "server_ip" {
  value = aws_instance.minecraft_server.public_ip
}