provider "aws" {
    region = "eu-central-1"
    shared_credentials_files = ["$HOME/.aws/credentials"]
}

terraform {
    backend "s3" {
        bucket = "litprinz-terraform-state"
        key = "L1_nuxtjs_project/terraform.tfstate"
        region = "eu-central-1"
  }
}

resource "aws_instance" "t2micro_ubuntu_test" {
    ami = "ami-06148e0e81e5187c8"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.allow_ports.id ]
    key_name = "ter_aws_key"
    tags = {
        Name = "t2micro_ubuntu_test"
        Env = "testing"
    }
    //user_data = file("user_data.sh")
}

resource "aws_security_group" "allow_ports" {
  name        = "allow_in_ports"
  description = "Allow particular inbound traffic" 

  dynamic "ingress" {
    for_each = ["22", "80", "8080", "3000"]
    content {
      description      = "open tcp ports"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  ingress {
    description      = "open icmp traffic"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound all packets"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tcp_icmp"
  }
}
