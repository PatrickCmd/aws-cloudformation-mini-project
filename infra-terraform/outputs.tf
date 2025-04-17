output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.compute.instance_id
}

output "public_ip" {
  description = "Elastic IP of the EC2 instance"
  value       = module.compute.public_ip
}

output "website_url" {
  description = "URL of the Apache web server"
  value       = "http://${module.compute.public_ip}"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i web-app-key.pem ubuntu@${module.compute.public_ip}"
  sensitive   = true
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = "${path.module}/web-app-key.pem"
  sensitive   = true
}