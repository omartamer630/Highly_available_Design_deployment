resource "aws_security_group" "forgtech_ec2_sg_vpc_1" {
  name        = "ec2-sg-vpc-1"
  description = "Security group for EC2 in VPC_1"
  vpc_id      = aws_vpc.vpc_1.id

  tags = {
    Name = "${var.environment}-EC2-SG-VPC1"
  }
}

# Ingress Rule for EC2 -> RDS
resource "aws_security_group_rule" "forgtech-rds-access-from-vpc1" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.forgtech_ec2_sg_vpc_1.id
  cidr_blocks       = [aws_vpc.vpc_1.cidr_block]           # Allow traffic from VPC_1 CIDR block
}

# Egress Rule for EC2 (allow outgoing traffic)
resource "aws_vpc_security_group_egress_rule" "forgtech-ec2-egress-vpc1" {
  security_group_id = aws_security_group.forgtech_ec2_sg_vpc_1.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
resource "aws_security_group" "forgtech_ec2_sg_vpc_2" {
  name        = "ec2-sg-vpc-2"
  description = "Security group for EC2 in VPC_2"
  vpc_id      = aws_vpc.vpc_2.id

  tags = {
    Name = "${var.environment}-EC2-SG-VPC2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "forgtech-ec2-ingress_vpc_2" {
  security_group_id = aws_security_group.forgtech_ec2_sg_vpc_2.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "forgtech_ec2s_ingress_2" {
  security_group_id = aws_security_group.forgtech_ec2_sg_vpc_2.id
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group_rule" "forgtech-rds-private-ingress" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.forgtech_ec2_sg_vpc_2.id
  cidr_blocks       = [aws_vpc.vpc_2.cidr_block]           # Allow traffic from VPC_2 CIDR block
}

resource "aws_vpc_security_group_egress_rule" "forgtech-ec2-egress_vpc_2" {
  security_group_id = aws_security_group.forgtech_ec2_sg_vpc_2.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_security_group" "forgtech_ec2_sg_vpc_3" {
  name        = "ec2-sg"
  description = "ec2 rules"
  vpc_id      = aws_vpc.vpc_3.id
  tags = {
    Name = "${var.environment}-EC2-SG-2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "forgtech-ec2-ingress_vpc_3" {
  security_group_id = aws_security_group.forgtech_ec2_sg_vpc_3.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "forgtech-ec2-egress_vpc_3" {
  security_group_id = aws_security_group.forgtech_ec2_sg_vpc_3.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
