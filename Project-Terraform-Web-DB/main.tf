provider "aws" {
  region = "us-east-1"   # Set your desired AWS region
}

# VPC definition remains the same
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnet 1 in us-east-1a
resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

# Subnet 2 in us-east-1d
resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1d"
}



# EC2 instance (Web server)
resource "aws_instance" "web_server" {
  ami           = "ami-0fff1b9a61dec8a5f"  # Replace with your AMI ID
  instance_type = "t3.micro"               # Replace with your desired instance type
  subnet_id     = aws_subnet.subnet_1.id   # Ensure you're using a subnet ID

  # Instead of security_groups, use vpc_security_group_ids
  vpc_security_group_ids = [aws_security_group.web_sg.id]  # Reference security group by ID

  tags = {
    Name = "WebServerInstance"
  }
   user_data = <<-EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Hello, Terraform!" > /var/www/html/index.html
  EOF
}





