#vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.Vpc_cidr_block

  tags = {
    Name = "vpc"
  }
}

#public_subnet
resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public_subnet"
  }
}

#security_groups
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_sg"
  }
}

#igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "main"
  }
}

#rw

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "example_association" {
  subnet_id  = aws_subnet.public_subnets.id
  route_table_id = aws_route_table.example.id
}

#ec2
resource "aws_instance" "ec2" {
  instance_type               = var.instance_type
  key_name                    = "Creds"
  ami                         = var.ami_type
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  subnet_id                   = aws_subnet.public_subnets.id
  associate_public_ip_address = true
  user_data                   = file("jenkins_install.sh")

  tags = {
    name        = "jenkins server"
    Terraform   = "true"
    Environment = "dev"
  }
}