variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "ID of the AMI to use"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use"
  type        = string
}

variable "private_ip" {
  description = "Private IP address for the instance"
  type        = string
}
