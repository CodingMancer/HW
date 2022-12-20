resource "aws_vpc" "ss_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "dev"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.ss_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    "Name" = "dev-public"
  }
}

resource "aws_internet_gateway" "ss_internet_gateway" {
  vpc_id = aws_vpc.ss_vpc.id
  tags = {
    "Name" = "dev-igw"
  }
}

resource "aws_route_table" "ss_public_rt" {
  vpc_id = aws_vpc.ss_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.ss_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ss_internet_gateway.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.ss_public_rt.id
}

resource "aws_security_group" "ss_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.ss_vpc.id

/*   ingress {
    description = "All incoming traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 */
  ingress {
    description = "All incoming HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "All incoming SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ss_key_pair" {
  key_name   = "sskey"
  public_key = file("~/.ssh/sskey.pub")
}

resource "aws_instance" "ss_instance" {
  instance_type          = "t2.micro"
  ami                    = "ami-0b5eea76982371e91"
  key_name               = aws_key_pair.ss_key_pair.id
  vpc_security_group_ids = [aws_security_group.ss_sg.id]
  subnet_id              = aws_subnet.public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "ss_ec2_instance"
  }

}