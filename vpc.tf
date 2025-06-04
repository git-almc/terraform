provider "aws" {
    region = "us-east-1"
}

#create vpc
resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "tf_vpc"
  }
}


#create public subnet
resource "aws_subnet" "tf_pub_subnet" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "tf_pub_subnet"
  }
}

#create private subnet
resource "aws_subnet" "tf_pri_subnet" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "tf_pri_subnet"
  }
}

#create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "igw"
  }
}

#create route table
resource "aws_route_table" "tf_route_tb" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf_vpc_rt"
  }
}

#adding routes
resource "aws_route" "tf_routes" {
  route_table_id = aws_route_table.tf_route_tb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

#create route to internet
resource "aws_route_table_association" "tf_route_ass" {
  subnet_id = aws_subnet.tf_pub_subnet.id
  route_table_id = aws_route_table.tf_route_tb.id
 }

