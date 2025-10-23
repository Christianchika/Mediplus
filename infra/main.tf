provider "aws" {
  region = var.aws_region
}

# SSH key
resource "aws_key_pair" "deployer" {
  key_name   = "k3s-key"
  public_key = file("C:/Users/user/.ssh/id_rsa.pub")
}

# Security group
resource "aws_security_group" "k3s_sg" {
  name        = "k3s_sg"
  description = "Allow K3s traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "k3s_master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.k3s_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "k3s-master"
  }
}

# Elastic IP
resource "aws_eip" "k3s_eip" {
  count    = var.allocate_eip ? 1 : 0
  instance = aws_instance.k3s_master.id
  vpc      = true
}

