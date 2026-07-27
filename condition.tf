#how to use condition
variable "environment" {
  default = "dev"
}

resource "aws_instance" "web1" {
  ami           = "ami-0b826bb6d96d2afe4"
  instance_type = var.environment == "prod" ? "t3.small" : "t3.micro"
  subnet_id = "subnet-0178"
  key_name = "example-1"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 10
  }
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.sg1.id]

   tags = {
    Name = "web1"
    Managed_by = "terraform"
  }
}
