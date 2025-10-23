output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.k3s_master.public_ip
}

output "elastic_ip" {
  description = "Elastic IP assigned to EC2 instance (if allocated)"
  value       = aws_eip.k3s_eip.public_ip
  condition   = var.allocate_eip
}



