output "web_server_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "Public IP of the webserver"
}

output "ecr_repo_url" {
  value       = aws_ecr_repository.mediplus-app.repository_url
  description = "URL of the ECR repository"
}

