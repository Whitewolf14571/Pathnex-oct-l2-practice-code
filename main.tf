terraform {
  required_version = ">= 1.5.0"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


provider "aws" {
  region = "ap-southeast-2"

}


data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "pathnex-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "pathnex-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name

}

resource "aws_security_group" "ec2_ssm_sg" {
  name        = "pathnex-ec2-ssm-sg"
  description = "EC2 access through SSM; no inbound access"
  vpc_id      = "vpc-0602df0d5e4a0c3bd"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "pathnex-ec2-ssm-sg"
    Environment = "learning"
  }
}



resource "aws_instance" "pathnex_ec2" {
  ami                         = data.aws_ssm_parameter.amazon_linux.value
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-0a021fc8e3a542db1"
  vpc_security_group_ids      = [aws_security_group.ec2_ssm_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name


  tags = {
    Name        = "pathnex-terraform-practice"
    Environment = "learning"
  }
}


