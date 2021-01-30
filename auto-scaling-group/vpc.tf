resource "aws_vpc" "mastercard" {
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "mastercard"
  }
}

resource "aws_internet_gateway" "internetgateway" {
  vpc_id = aws_vpc.mastercard.id
  tags = {
    Name = "gw"
  }
}

resource "aws_subnet" "mastercard" {
  vpc_id     = aws_vpc.mastercard.id
  cidr_block = "10.1.0.0/16"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "MasterVPC"
  }
}

resource "aws_route_table" "mastercard" {
  vpc_id = aws_vpc.mastercard.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetgateway.id
  }
}

resource "aws_route_table_association" "mastercard" {
  subnet_id      = aws_subnet.mastercard.id
  route_table_id = aws_route_table.mastercard.id
}

