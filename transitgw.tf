# Transit GW Creation
resource "aws_ec2_transit_gateway" "forgtech_transit_gw" {
  description                     = "managing the internet traffic flow-driven from/to the private subnets to the public subnets"
  default_route_table_association = "disable"
}

# VPC_1  attachment with TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "attach_rtb_1_to_tgw" {
  subnet_ids         = [aws_subnet.vpc_1_private_subnet_asg_a.id, aws_subnet.vpc_1_private_subnet_asg_b.id, aws_subnet.vpc_1_private_subnet_rds_a.id, aws_subnet.vpc_1_private_subnet_rds_b.id]
  transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id
  vpc_id             = aws_vpc.vpc_1.id
}

# VPC_2  attachment with TGW

resource "aws_ec2_transit_gateway_vpc_attachment" "attach_rtb_2_to_tgw" {
  subnet_ids         = [aws_subnet.vpc_2_private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id
  vpc_id             = aws_vpc.vpc_2.id
}

# VPC_3  attachment with TGW

resource "aws_ec2_transit_gateway_vpc_attachment" "attach_rtb_3_to_tgw" {
  subnet_ids         = [aws_subnet.vpc_3_public_subnet.id, aws_subnet.vpc_3_private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id
  vpc_id             = aws_vpc.vpc_3.id
}
