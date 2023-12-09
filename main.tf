terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "gabs_user"
  region  = "us-east-1"
}

resource "aws_instance" "ec2_instance" {
  count         = 2
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.nano"
  key_name      = "ittalent-terraform-key-pair"

  tags = {
    Name = "ITTalent-Terraform-${count.index + 1}"
  }

  timeouts {
    create = "60m"
  }

  user_data = file("${path.module}/user-data-nginx.sh")
}

output "ec2_public_ips" {
  value = aws_instance.ec2_instance[*].public_ip
}
