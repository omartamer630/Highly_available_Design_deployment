
resource "aws_internet_gateway" "vpc_3_internet_gateway" {
  vpc_id = aws_vpc.vpc_3.id
  tags = {
    Name = "${var.environment}-vpc-igw-3"
  }
}

resource "aws_eip" "eip_for_natgw" {
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "forgtech_pub_vpc_3_nat_gw" {
  allocation_id = aws_eip.eip_for_natgw.id
  subnet_id     = aws_subnet.vpc_3_public_subnet.id

  tags = {
    Name = "${var.environment}-nat"
  }
  depends_on = [aws_internet_gateway.vpc_3_internet_gateway]
}
