# AWS Infrastructure with Terraform

This Terraform configuration sets up a basic AWS infrastructure with a VPC, public subnet, and an EC2 instance running Apache web server.

## Infrastructure Components

- **VPC**: A virtual private cloud with public subnet
- **Internet Gateway**: Enables internet access for the public subnet
- **Route Table**: Routes traffic to the internet gateway
- **Security Group**: Allows SSH (22) and HTTP (80) access
- **EC2 Instance**: Ubuntu 24.04 LTS server running Apache
- **Key Pair**: Automatically generated SSH key pair

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- AWS provider >= 5.45.0
- TLS provider >= 4.0
- Local provider >= 2.0

## Configuration

The infrastructure is configured with the following defaults:

- **Region**: us-east-1
- **VPC CIDR**: 10.0.0.0/16
- **Public Subnet CIDR**: 10.0.0.0/24
- **Instance Type**: t2.micro
- **AMI**: Ubuntu 24.04 LTS
- **Storage**: EBS gp3

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the execution plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply --auto-approve
   ```

4. After successful deployment, you can:
   - Access the web server at: `http://<instance-public-ip>`
   - SSH into the instance using the provided command
   - View all outputs with: `terraform output`

## Outputs

After deployment, Terraform will output:
- VPC ID
- Public Subnet ID
- EC2 Instance ID
- Instance Public IP
- Website URL
- SSH Command
- Private Key Path

## SSH Access

The SSH private key is automatically generated and saved as `web-app-key.pem`. To connect to the instance:

```bash
ssh -i web-app-key.pem ubuntu@<instance-public-ip>
```

Make sure to set the correct permissions on the private key file:
```bash
chmod 400 web-app-key.pem
```

## Security Notes

- The private key file is automatically generated with secure permissions (0400)
- The security group allows SSH access from anywhere (0.0.0.0/0)
- Consider restricting SSH access to specific IP ranges in production

## Cleanup

To destroy all created resources:
```bash
terraform destroy
```

## Module Structure

- `modules/vpc`: Manages VPC, subnet, and networking components
- `modules/compute`: Manages EC2 instance and security group
- Root module: Orchestrates the infrastructure and manages the key pair

## Variables

| Name | Description | Default |
|------|-------------|---------|
| region | AWS region | us-east-1 |
| vpc_cidr | VPC CIDR block | 10.0.0.0/16 |
| public_subnet_cidr | Public subnet CIDR block | 10.0.0.0/24 |
| instance_type | EC2 instance type | t2.micro | 