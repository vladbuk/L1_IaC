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

data "aws_ami" "ubuntu20_latest" {
    owners = [ "099720109477" ]
    most_recent = true
    
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}

resource "aws_instance" "t2micro_ubuntu_test" {
    ami = data.aws_ami.ubuntu20_latest.id
    instance_type = "t2.micro"
    key_name = "ter_aws_key"
    vpc_security_group_ids = [ aws_security_group.allow_ports.id ]
    subnet_id = aws_subnet.subnet1.id
    private_ip = "172.16.1.100"

    tags = {
        Name = "t2micro_ubuntu_test"
        Env = "testing"
    }
    //user_data = file("user_data.sh")
}

resource "aws_instance" "t2micro_ubuntu_prod" {
    ami = data.aws_ami.ubuntu20_latest.id
    instance_type = "t2.micro"
    key_name = "ter_aws_key"
    vpc_security_group_ids = [ aws_security_group.allow_ports.id ]
    subnet_id = aws_subnet.subnet1.id
    private_ip = "172.16.1.1"

    tags = {
        Name = "t2micro_ubuntu_prod"
        Env = "production"
    }
}
