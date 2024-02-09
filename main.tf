terraform {
  required_providers {
    aws = { 
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_key_pair" "terraform_instance_key" {
  key_name   = "terraform_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "pem_folder" {
  content  = tls_private_key.rsa.private_key_pem 
  filename = "terraform_key"
}


