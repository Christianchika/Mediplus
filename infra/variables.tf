variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type for K3s master"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
  default     = "ami-0e86e20dae9224db8" # Update per region
}

variable "allocate_eip" {
  description = "Whether to allocate an Elastic IP for EC2 instance"
  type        = bool
  default     = true
}

