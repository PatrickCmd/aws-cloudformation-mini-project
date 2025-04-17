resource "tls_private_key" "web" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "web" {
  key_name   = "web-app-key"
  public_key = tls_private_key.web.public_key_openssh

  tags = {
    Name = "web-app-key"
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.web.private_key_pem
  filename        = "${path.module}/web-app-key.pem"
  file_permission = "0400"
} 