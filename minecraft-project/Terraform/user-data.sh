#!/bin/bash
yum update -y
apt update && apt install -y docker.io docker-compose
usermod -aG docker ubuntu
