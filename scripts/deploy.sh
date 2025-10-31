#!/bin/bash
set -e

APP_NAME="mediplus"
DOMAIN="mypodsix.online"
REGION="eu-north-1"
ECR_REPO_URL="${ECR_REPO_URL}"

echo "==== Updating system ===="
sudo apt update -y
sudo apt install -y docker.io docker-compose nginx awscli

sudo systemctl enable docker nginx
sudo systemctl start docker nginx

echo "==== Login to ECR ===="
aws ecr get-login-password --region $REGION | sudo docker login --username AWS --password-stdin $ECR_REPO_URL

echo "==== Pull latest Docker image ===="
for i in {1..3}; do
  sudo docker pull $ECR_REPO_URL:latest && break
  echo "Retrying docker pull..."
  sleep 5
done

echo "==== Run Mediplus container ===="
sudo docker stop $APP_NAME || true
sudo docker rm $APP_NAME || true
sudo docker run -d --name $APP_NAME -p 3000:3000 $ECR_REPO_URL:latest

echo "==== Configure Nginx reverse proxy ===="
cat <<EOF | sudo tee /etc/nginx/sites-available/$APP_NAME
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# echo "==== Issue Let's Encrypt SSL certificate ===="
# sudo certbot --nginx -d $DOMAIN -m okoro.christianpeace@gmail.com --agree-tos --non-interactive
# sudo systemctl restart nginx
# sudo systemctl enable certbot.timer

echo "==== Deployment complete ===="
echo "App available at: http://$DOMAIN"


