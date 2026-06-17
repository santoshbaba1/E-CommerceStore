# VPC Creation
resource "aws_vpc" "ec_main" { 
  cidr_block = "10.0.0.0/16"
}   

# Public Subnet Creation
resource "aws_subnet" "ecommerce_public" {
  vpc_id            = aws_vpc.ec_main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}   

# Internet Gateway Creation
resource "aws_internet_gateway" "ecommerce_igw" {
  vpc_id = aws_vpc.ec_main.id   
}   

# Route Table Creation
resource "aws_route_table" "ecommerce_public_rt" {  
  vpc_id = aws_vpc.ec_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecommerce_igw.id
  }         
}   

# Route Table Association
resource "aws_route_table_association" "ecommerce_public_rta" { 
  subnet_id      = aws_subnet.ecommerce_public.id
  route_table_id = aws_route_table.ecommerce_public_rt.id
}

# Security Group Creation
resource "aws_security_group" "ecommerce_sg" { 
  name        = "ecommerce_sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.ec_main.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]         
      }
      
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]         
      }
      
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]         
      }

    ingress {
        from_port   = 3000
        to_port     = 3004
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
