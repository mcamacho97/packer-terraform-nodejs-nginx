terraform {

  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

}

provider "aws" {
  region = "us-east-1"
}

locals {

  manifest = jsondecode(
    file("${path.module}/../packer/manifest.json")
  )

  ami_id = split(
    ":",
    local.manifest.builds[0].artifact_id
  )[1]

}

resource "aws_security_group" "web" {

  name = "node-nginx-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "web" {

  ami           = local.ami_id
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  tags = {
    Name = "node-nginx-demo"
  }

}