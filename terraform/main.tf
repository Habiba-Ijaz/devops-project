terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

variable "dockerhub_user" {
  type    = string
  default = "habibaijaz"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-*-amd64-server-*"]
  }
}

resource "aws_security_group" "app" {
  name        = "devops-project-sg"
  description = "Allow HTTP"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    systemctl enable --now docker
    docker run -d --restart unless-stopped -p 80:5000 ${var.dockerhub_user}/devops-project:latest
  EOF

  tags = {
    Name = "devops-project"
  }
}

output "public_ip" {
  value = aws_instance.app.public_ip
}

output "url" {
  value = "http://${aws_instance.app.public_ip}"
}
