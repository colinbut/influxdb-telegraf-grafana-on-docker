terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "host_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name_pair

  vpc_security_group_ids = [ aws_security_group.security_group.id ]

  user_data = templatefile("${path.cwd}/bootstrap.tmpl", {})

  tags = {
    "Name" = "InfluxDB_Telegraf_Host_Server"
  }
}

resource "aws_security_group" "security_group" {
  name = "host_server_sg"
  description = "The SG that allows both ssh & access to grafana via the web"
}

resource "aws_security_group_rule" "allow_access_to_grafana" {
    type                = "ingress"
    description         = "allowing access to Grafana on default port"
    from_port           = 3000
    to_port             = 3000
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"] # for demo purposes i'm allowing from every one
    security_group_id   = aws_security_group.security_group.id
}

resource "aws_security_group_rule" "allow_ssh_from_outside" {
    type                = "ingress"
    description         = "allow ssh from outside"
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"] # for demo purposes i'm allowing from every one
    security_group_id   = aws_security_group.security_group.id
}

resource "aws_security_group_rule" "default_outbound" {
    type                = "egress"
    description         = "default_outbound"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.security_group.id
}