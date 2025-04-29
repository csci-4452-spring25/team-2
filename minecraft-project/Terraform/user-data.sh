#!/bin/bash
set -e

# Update system
dnf update -y

# Install Docker
dnf install -y docker

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to Docker group
usermod -aG docker ec2-user

# Install Docker Compose v2 (plugin-based)
mkdir -p /usr/libexec/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/libexec/docker/cli-plugins/docker-compose
chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# Create working directory
mkdir -p /home/ec2-user/minecraft-server
chown -R ec2-user:ec2-user /home/ec2-user/minecraft-server

echo "✅ Docker and Docker Compose installed successfully"


docker --version