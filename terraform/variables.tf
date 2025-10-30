variable "aws_region" {
  default = "eu-north-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "stagging-key"
  description = "Existing AWS EC2 key pair name"
}

variable "domain_name" {
  default = "mypodsix.online"
}

variable "email" {
  default = "okoro.christianpeace@gmail.com"
}
