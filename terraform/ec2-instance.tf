# EC2 Instance Creation
resource "aws_instance" "ecommerce_instance" {
  ami           = "ami-0f8a61b66d1accaee" # Amazon Linux 2 AMI
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.ecommerce_public.id
  
  security_groups = [aws_security_group.ecommerce_sg.id]  
  key_name      = "terraform-keypair" # Replace with your key pair name

  user_data = file("userdata.sh") 
  tags = {
    Name = "EcommerceInstance"
  }
} 
