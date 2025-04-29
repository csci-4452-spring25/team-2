#!/bin/bash
set -e

# Injected by Terraform
export github_token="${github_token}"

# Update system and install Docker and Git
dnf update -y
dnf install -y docker git

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to Docker group
usermod -aG docker ec2-user

# Install Docker Compose v2
mkdir -p /usr/libexec/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/libexec/docker/cli-plugins/docker-compose
chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# Clone private GitHub repo using the injected token
git clone https://${github_token}@github.com/csci-4452-spring25/team-2.git /home/ec2-user/team2
chown -R ec2-user:ec2-user /home/ec2-user/team2

echo "✅ Docker, Docker Compose, and Git repo setup complete"

# Run the project
cd /home/ec2-user/team2/minecraft-project
sudo -u ec2-user docker compose up -d
#!/bin/bash
set -e

# Injected by Terraform
export github_token="${github_token}"

# Update system and install Docker and Git
dnf update -y
dnf install -y docker git

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to Docker group
usermod -aG docker ec2-user

# Install Docker Compose v2
mkdir -p /usr/libexec/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/libexec/docker/cli-plugins/docker-compose
chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# Clone private GitHub repo using the injected token
git clone https://${github_token}@github.com/csci-4452-spring25/team-2.git /home/ec2-user/team2
chown -R ec2-user:ec2-user /home/ec2-user/team2

echo "✅ Docker, Docker Compose, and Git repo setup complete"

# Run the project
cd /home/ec2-user/team2/minecraft-project
sudo -u ec2-user docker compose up -d