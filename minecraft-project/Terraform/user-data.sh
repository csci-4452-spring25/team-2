#!/bin/bash
apt-get update
apt-get install -y docker.io
usermod -aG docker ubuntu
docker run -d -p 25565:25565 your-docker-image-name
