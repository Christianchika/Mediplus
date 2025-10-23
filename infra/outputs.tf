output "instance_ip" {
  value = aws_instance.k3s_master.public_ip
}

output "elastic_ip" {
  value = aws_eip.k3s_eip.public_ip
}



