provider "aws" {
  region = var.region
}


resource "random_string" "random" {
  length           = 8
  special          = false
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.prefix}-${random_string.random.result}-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.prefix}-${random_string.random.result}-subnet"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-${random_string.random.result}-route-table"
  }
}

resource "aws_route" "main" {
  route_table_id         = aws_route_table.main.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-${random_string.random.result}-igw"
  }
}

resource "aws_network_interface" "dev" {
  subnet_id = aws_subnet.main.id
  security_groups = [ aws_security_group.allow_ssh.id ]

  tags = {
    Name = "${var.prefix}-${random_string.random.result}-interface"
  }
}

resource "aws_instance" "dev" {
  ami           = var.ami
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.dev.id
    device_index         = 0
  }
  tags = {
    Name = "${var.prefix}-${random_string.random.result}-dev-instance"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
