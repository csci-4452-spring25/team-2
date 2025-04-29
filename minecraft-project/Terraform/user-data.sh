#!/bin/bash
apt update && apt install -y docker.io docker-compose
usermod -aG docker ubuntu
