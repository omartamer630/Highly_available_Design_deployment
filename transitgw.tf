# Transit GW Creation
resource "aws_ec2_transit_gateway" "forgtech_transit_gw" {
  description                     = "managing the internet traffic flow-driven from/to the private subnets to the public subnets"
  default_route_table_association = "disable"
  dns_support                     = "enable"

}

# VPC_1  attachment with TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "attach_rtb_1_to_tgw" {
  subnet_ids         = [aws_subnet.vpc_1_private_subnet_asg_a.id, aws_subnet.vpc_1_private_subnet_asg_b.id]
  transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id
  vpc_id             = aws_vpc.vpc_1.id
}

resource "aws_ec2_transit_gateway_route_table_association" "assoc_vpc_1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_rtb_1_to_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.forgtech_tgw_rt.id
}

# VPC_2  attachment with TGW

resource "aws_ec2_transit_gateway_vpc_attachment" "attach_rtb_2_to_tgw" {
  subnet_ids         = [aws_subnet.vpc_2_private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id
  vpc_id             = aws_vpc.vpc_2.id
}


resource "aws_ec2_transit_gateway_route_table_association" "assoc_vpc_2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_rtb_2_to_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.forgtech_tgw_rt.id
}


# VPC_3  attachment with TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "attach_rtb_3_to_tgw" {
  subnet_ids         = [aws_subnet.vpc_3_private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.forgtech_transit_gw.id
  vpc_id             = aws_vpc.vpc_3.id
}

resource "aws_ec2_transit_gateway_route_table_association" "assoc_vpc_3" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_rtb_3_to_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.forgtech_tgw_rt.id
}
