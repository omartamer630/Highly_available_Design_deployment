# Generate a new key pair for the jumper to access private instances
resource "tls_private_key" "private_key_ec2s" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "private_key_ec2s_pair" {
  key_name   = "private_key_ec2s"
  public_key = tls_private_key.private_key_ec2s.public_key_openssh
}
# Bastion Host for VPC 3 for Testing propose
resource "aws_instance" "bastion_host" {
  ami                         = "ami-0182f373e66f89c85"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.vpc_3_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.vpc_3_security_group.id]
  associate_public_ip_address = true
  key_name                    = "forgtech-keypair"

  user_data = <<-EOF
              #!/bin/bash
              mkdir -p /home/ec2-user/.ssh
              echo '${tls_private_key.private_key_ec2s.private_key_pem}' > /home/ec2-user/.ssh/private_key_ec2s.pem
              chmod 600 /home/ec2-user/.ssh/private_key_ec2s.pem
              chown ec2-user:ec2-user /home/ec2-user/.ssh/private_key_ec2s.pem
              EOF
  tags = {
    Name = "${var.environment}-bastion-host"
  }
}
# Bastion Host for VPC 2 for Testing propose
resource "aws_instance" "ec2_vpc_2" {
  ami                    = "ami-0182f373e66f89c85"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.vpc_2_private_subnet.id
  vpc_security_group_ids = [aws_security_group.vpc_2_security_group.id]
  key_name               = aws_key_pair.private_key_ec2s_pair.key_name

  user_data = <<-EOF
              #!/bin/bash
              mkdir -p /home/ec2-user/.ssh
              echo '${tls_private_key.private_key_ec2s.private_key_pem}' > /home/ec2-user/.ssh/private_key_ec2s.pem
              chmod 600 /home/ec2-user/.ssh/private_key_ec2s.pem
              chown ec2-user:ec2-user /home/ec2-user/.ssh/private_key_ec2s.pem
              EOF

  tags = {
    Name = "${var.environment}-ec2-vpc-2"
  }
}
