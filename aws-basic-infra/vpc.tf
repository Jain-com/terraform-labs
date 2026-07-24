#VPC
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.client_name}-vpc"
    Managed_by = "${var.managed_by}"
  }
}
# Internet Gateway

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "${var.client_name}-igw1"
    Managed_by = "${var.managed_by}"
  }
}

# Public subnet 1

resource "aws_subnet" "pub_ssubnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${var.client_name}-pub_sub1"
    Managed_by = "${var.managed_by}"
  }
}

# Private subnet 1

resource "aws_subnet" "pvt_subnet1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.client_name}-pvt_sub1"
    Managed_by = "${var.managed_by}"
  }
}

# Public RT 1

resource "aws_route_table" "pub_rt1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }

  tags = {
    Name = "${var.client_name}-pub_rt1"
    Managed_by = "${var.managed_by}"
  }
}

# Private RT 1

resource "aws_route_table" "pvt_rt1" {
  vpc_id = aws_vpc.vpc1.id

#below commenting because if we use it, then it will be public again
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.igw1.id
  # }

  tags = {
    Name = "${var.client_name}-pvt_rt1"
    Managed_by = "${var.managed_by}"
  }
}
# Public subnet 1 association
resource "aws_route_table_association" "pubsub1_rt1" {
  subnet_id      = aws_subnet.pub_ssubnet1.id
  route_table_id = aws_route_table.pub_rt1.id
}
# Private subnet 1 association
resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.pvt_subnet1.id
  route_table_id = aws_route_table.pvt_rt1.id
}
# Security group 1

resource "aws_security_group" "sg1" {
  name        = "${var.client_name}-sg1"
  #description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc1.id

   ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["116.73.154.167/32", aws_vpc.vpc1.cidr_block]
    
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.client_name}-sg1"
    Managed_by = "${var.managed_by}"
  }
}


# EC2 - web1

resource "aws_instance" "web1" {
  ami           = "ami-0b826bb6d96d2afe4"
  instance_type = var.my-instance-type
  subnet_id = aws_subnet.pub_ssubnet1.id
  key_name = "example-1"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.sg1.id]

   tags = {
    Name = "${var.client_name}-web1"
    Managed_by = "${var.managed_by}"
  }
}

# EC2 - DB1

resource "aws_instance" "db1" {
  ami           = "ami-0b826bb6d96d2afe4"
  instance_type = var.my-instance-type
  subnet_id = aws_subnet.pvt_subnet1.id
  key_name = "example-1"
  
  vpc_security_group_ids = [aws_security_group.sg1.id]

   tags = {
    Name = "${var.client_name}-db1"
    Managed_by = "${var.managed_by}"
  }
}

#below will show output here itself we don't need to go to console 
#to check every time we do terraform apply

output "my_web1_public_ip" {
  value = aws_instance.web1.public_ip
}

output "my_web1_private_ip" {
  value = aws_instance.web1.private_ip
}

output "my_db1_public_ip" {
  value = aws_instance.db1.private_ip
}
