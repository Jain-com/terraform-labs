provider "aws" {
  region = "us-east-1"
}

module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

  name = "flipkart-vpc-dev"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

 

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "sg1" {
  name        = "flipkart-vpc-sg1"
  #description = "Allow TLS inbound traffic and all outbound traffic"
  #module.vpc1.vpc_id this vpc_id we got it from tfstate
  
  vpc_id      = module.vpc1.vpc_id
  
   ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["116.73.124.53/32"]
    
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
    Name = "flipkart"
    Managed_by = "terraform"
  }
}

resource "aws_instance" "web1" {
  ami           = "ami-0b826bb6d96d2afe4"
  instance_type = "t3.micro"
  subnet_id = module.vpc1.public_subnets[0]
  key_name = "example-1"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.sg1.id]

   tags = {
    Name = "web1"
    Managed_by = "terraform"
  }
}

output "my_web1_public_ip" {
  value = aws_instance.web1.public_ip
  
}

output "my_web1_private_ip" {
  value = aws_instance.web1.private_ip
  
}
