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
  filename = "terraform_key.pem"
}

resource "aws_instance" "testing_server"{
  ami =  "ami-0277155c3f0ab2930"
  instance_type = "t2.micro"
  key_name = "terraform_key"
  tags = {
    Name = "testing_server"
    Description = "This is a testing server"
  }
}

resource "aws_sns_topic" "terraform_topic"{
    name = "sns_topic_tf" 
}

resource "aws_sns_topic_subscription" terraform_subcrption{
  topic_arn = aws_sns_topic.terraform_topic.arn
  protocol = "email"
  endpoint = "purushothshanmugam19@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "terraform_metric" {
  alarm_name                = "terraform-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "This metric monitors ec2 cpu utilization"
  actions_enabled           = "true"
  alarm_actions             = [aws_sns_topic.terraform_topic.arn]
  ok_actions                = [aws_sns_topic.terraform_topic.arn]
  dimensions ={
      InstanceId = aws_instance.testing_server.id
  }  
}

