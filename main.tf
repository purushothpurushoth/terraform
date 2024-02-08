terraform {
  required_providers {
    aws = { 
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_key_pair" "pem_key" {
  key_name   = "pem-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "local" {
  content  = tls_private_key.rsa.private_key_pem 
  filename = "tfkey"
}

resource "aws_instance" "Purushoth_Terraform_Instance"{
  ami                    = "ami-0f5ee92e2d63afc18"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.pem_key.key_name

 tags = {
    Name = "public_instance"
  }

 root_block_device {
   volume_size = 30
   volume_type = "gp2"
  }
}