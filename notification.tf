terraform {
  required_providers {
    aws = { 
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_sns_topic" "terraform_sns_topic"{
    name = sns_topic_tf
}