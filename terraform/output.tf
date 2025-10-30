# outputs.tf

# Web server public IP
output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web_server.public_ip
}

# Reverse proxy public IP
output "reverse_proxy_public_ip" {
  description = "Public IP of the reverse proxy"
  value       = aws_instance.reverse_proxy.public_ip
}

# ECR repository URL
output "ecr_repo_url" {
  description = "ECR repository URI"
  value       = aws_ecr_repository.mediplus-app.repository_url
}
