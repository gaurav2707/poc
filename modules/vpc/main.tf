provider "aws" {
  region = var.region  # Change to your desired region
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_a_cidr
  availability_zone = var.az_a
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet Dev"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-gateway"
  }
}

# Create a NAT Gateway
resource "aws_eip" "nat" {
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet-a.id
  tags = {
    Name = "nat-gateway"
  }
}

# Create a Route Table for the Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-route-table"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.subnet-a.id
  route_table_id = aws_route_table.private_rt.id
}

# Add a route to the NAT Gateway
resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.us-east-2.ssm"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.subnet-a.id]
  security_group_ids = [aws_security_group.ec2_sg.id]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.us-east-2.ec2messages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.subnet-a.id]
  security_group_ids = [aws_security_group.ec2_sg.id]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.us-east-2.ssmmessages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.subnet-a.id]
  security_group_ids = [aws_security_group.ec2_sg.id]
}

# Create a Security Group
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-sg-"
  vpc_id      = aws_vpc.main.id


  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block] # No inbound access allowed
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

 #output "security_group_id" {
  # value = aws_security_group.ec2_sg.id
  
 #}