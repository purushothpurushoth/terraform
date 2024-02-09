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

resource "aws_instance" "testing_server"{
  ami =  "ami-0277155c3f0ab2930"
  instance_type = "t2.micro"
  key_name = "terraform_key"
  tags = {
    Name = "testing_server"
    Description = "This is a testing server"
  }

resource "aws_sns_topic" "terraform_sns_topic"{
    name = "sns_topic_tf" 
}

}

