# VPC_1 Route Table

# VPC 1  RTB and routes
resource "aws_route_table" "vpc_1_route_table" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id
  }
  tags = {
    Name = "${var.environment}-vpc-1-rtb-1"
  }
}

# Associate RTB 1 To private subnet asg a
resource "aws_route_table_association" "associate_route_table_1_to_vpc_1_private_subnet_asg_a" {
  subnet_id      = aws_subnet.vpc_1_private_subnet_asg_a.id
  route_table_id = aws_route_table.vpc_1_route_table.id
}

# Associate RTB 1 To private subnet asg b
resource "aws_route_table_association" "associate_route_table_1_to_vpc_1_private_subnet_asg_b" {
  subnet_id      = aws_subnet.vpc_1_private_subnet_asg_b.id
  route_table_id = aws_route_table.vpc_1_route_table.id
}

# Associate RTB 1 To private subnet rds a
resource "aws_route_table_association" "associate_route_table_1_to_vpc_1_private_subnet_rds_a" {
  subnet_id      = aws_subnet.vpc_1_private_subnet_rds_a.id
  route_table_id = aws_route_table.vpc_1_route_table.id
}

# Associate RTB 1 To private subnet rds b
resource "aws_route_table_association" "associate_route_table_1_to_vpc_1_private_subnet_rds_b" {
  subnet_id      = aws_subnet.vpc_1_private_subnet_rds_b.id
  route_table_id = aws_route_table.vpc_1_route_table.id
}

# VPC_2 Route Table

# VPC 2 RTB and routes
resource "aws_route_table" "vpc_2_route_table" {
  vpc_id = aws_vpc.vpc_2.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id
  }
  tags = {
    Name = "${var.environment}-vpc-rtb-2"
  }
}

# Associate RTB 2 To vpc 2 private subnet 
resource "aws_route_table_association" "associate_route_table_2_to_subnet" {
  subnet_id      = aws_subnet.vpc_2_private_subnet.id
  route_table_id = aws_route_table.vpc_2_route_table.id
}

# VPC_3 Route Table

# VPC_3 Public RTB and routes
resource "aws_route_table" "vpc_3_public_route_table" {
  vpc_id = aws_vpc.vpc_3.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_3_internet_gateway.id
  }

  tags = {
    Name = "${var.environment}-vpc-rtb-3"
  }
}

# Associate Public RTB to vpc 3 public subnet 
resource "aws_route_table_association" "associate_route_table_3_to_subnet" {
  subnet_id      = aws_subnet.vpc_3_public_subnet.id
  route_table_id = aws_route_table.vpc_3_public_route_table.id
}

# VPC_3 private RTB and routes
resource "aws_route_table" "vpc_3_private_route_table" {
  vpc_id = aws_vpc.vpc_3.id

  route {
    cidr_block         = aws_vpc.vpc_1.cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id
  }
  route {
    cidr_block         = aws_vpc.vpc_2.cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id

  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.forgtech_pub_vpc_3_nat_gw.id
  }

  tags = {
    Name = "${var.environment}-vpc-3-private-rtb-3"
  }
}

# Associate Private RTB to vpc 3 private subnet 
resource "aws_route_table_association" "associate_vpc_3_private_subnet" {
  subnet_id      = aws_subnet.vpc_3_private_subnet.id
  route_table_id = aws_route_table.vpc_3_private_route_table.id
}

# Transit GW Routes

resource "aws_ec2_transit_gateway_route_table" "forgtech_tgw_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id
  tags = {
    Name = "${var.environment}-tgw-route-table"
  }
}

# Transit GW VPC_1 Route
resource "aws_ec2_transit_gateway_route_table_association" "assoc_vpc_1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_rtb_1_to_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.forgtech_tgw_rt.id
}

resource "aws_ec2_transit_gateway_route" "route_to_vpc_1" {
  destination_cidr_block         = aws_vpc.vpc_1.cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.forgtech_tgw_rt.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_rtb_1_to_tgw.id
}

# Transit GW VPC_2 Route

resource "aws_ec2_transit_gateway_route_table_association" "assoc_vpc_2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_rtb_2_to_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.forgtech_tgw_rt.id
}

resource "aws_ec2_transit_gateway_route" "route_to_vpc_2" {
  destination_cidr_block         = aws_vpc.vpc_2.cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.forgtech_tgw_rt.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_rtb_2_to_tgw.id
}

# Transit GW VPC_3 Route

resource "aws_ec2_transit_gateway_route_table_association" "assoc_vpc_3" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_rtb_3_to_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.forgtech_tgw_rt.id
}

resource "aws_ec2_transit_gateway_route" "route_to_vpc_3" {
  destination_cidr_block         = aws_vpc.vpc_2.cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.forgtech_tgw_rt.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_rtb_3_to_tgw.id
}
