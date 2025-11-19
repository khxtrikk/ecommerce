terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "deploy_key" {
  key_name   = "mern_deploy_key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "app_sg" {
  name        = "mern-app-sg"
  description = "Allow SSH and API"

  # Ingress rules
  ingress {
    description      = "SSH from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  ingress {
    description      = "API port open"
    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  # Egress rules (allow all outbound)
  egress {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "app" {
  ami                          = data.aws_ami.ubuntu.id
  instance_type                = var.instance_type
  key_name                     = aws_key_pair.deploy_key.key_name
  vpc_security_group_ids       = [aws_security_group.app_sg.id]
  associate_public_ip_address  = true
  tags = {
    Name = "mern-app-server"
  }
}

output "app_public_ip" {
  value = aws_instance.app.public_ip
}
