#!/bin/bash
set -e

DOMAIN="mypodsix.online"
REGION="eu-north-1"
ECR_REPO_URL="503640389215.dkr.ecr.eu-north-1.amazonaws.com/mediplus-app"

echo "==== Updating system ===="
sudo apt update -y
sudo apt install -y docker.io docker-compose awscli

sudo systemctl enable docker
sudo systemctl start docker

echo "==== Login to ECR ===="
aws ecr get-login-password --region $REGION | sudo docker login --username AWS --password-stdin $ECR_REPO_URL

echo "==== Pull latest Docker image ===="
sudo docker pull $ECR_REPO_URL:latest

echo "==== Start services using Docker Compose ===="
sudo docker-compose down || true
sudo docker-compose up -d --remove-orphans

echo "==== Deployment complete ===="
echo "App available at: http://$DOMAIN"



