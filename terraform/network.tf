resource "aws_vpc" "main_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "Name" = "main_vpc"
    "Env" = "test"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "172.16.1.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "172.16.2.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Subnet2"
  }
}

# resource "aws_network_interface" "ether1" {
#   subnet_id = aws_subnet.subnet1.id
#   private_ips = [ "172.16.1.10" ]
#   security_groups = [ aws_security_group.allow_ports.id ]
#   tags = {
#     "Name" = "primary_net_interface"
#   }
# }

resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_gateway"
  }
}

resource "aws_route_table" "main_route" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }
  tags = {
      Name = "main_route"
  }
}

resource "aws_route_table_association" "main_route_asso" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.main_route.id
}

resource "aws_route_table_association" "main_route_asso2" {
  subnet_id = aws_subnet.subnet2.id
  route_table_id = aws_route_table.main_route.id
}


#-------------------------------------------------#

resource "aws_security_group" "allow_ports" {
  name        = "allow_in_ports"
  description = "Open only needed ports"
  vpc_id      = aws_vpc.main_vpc.id 

  dynamic "ingress" {
    for_each = ["22", "80", "443", "8080"]
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
    Name = "allow_in_ports"
  }
}
