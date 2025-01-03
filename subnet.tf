# VPC_1 Subnets
resource "aws_subnet" "vpc_1_private_subnet_asg_a" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_1.cidr_block, 8, 0)
  availability_zone = "${var.AWS_DEFAULT_REGION}a"
  tags = {
    Name = "${var.environment}-vpc-1-priv-subnet-asg-a"
  }
}
resource "aws_subnet" "vpc_1_private_subnet_asg_b" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_1.cidr_block, 8, 1)
  availability_zone = "${var.AWS_DEFAULT_REGION}b"
  tags = {
    Name = "${var.environment}-vpc-1-priv-subnet-asg-b"
  }
}

resource "aws_subnet" "vpc_1_private_subnet_rds_a" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_1.cidr_block, 8, 2)
  availability_zone = "${var.AWS_DEFAULT_REGION}a"
  tags = {
    Name = "${var.environment}-vpc-1-priv-subnet-rds-a"
  }
}

resource "aws_subnet" "vpc_1_private_subnet_rds_b" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_1.cidr_block, 8, 3)
  availability_zone = "${var.AWS_DEFAULT_REGION}b"
  tags = {
    Name = "${var.environment}-vpc-1-priv-subnet-rds-b"
  }
}

# VPC_2 Subnets
resource "aws_subnet" "vpc_2_private_subnet" {
  vpc_id            = aws_vpc.vpc_2.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_2.cidr_block, 8, 0)
  availability_zone = "${var.AWS_DEFAULT_REGION}b"
  tags = {
    Name = "${var.environment}-vpc-2-priv-subnet"
  }
}

# VPC_3 Subnets
resource "aws_subnet" "vpc_3_public_subnet" {
  vpc_id            = aws_vpc.vpc_3.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_3.cidr_block, 8, 0)
  availability_zone = "${var.AWS_DEFAULT_REGION}b"
  tags = {
    Name = "${var.environment}-vpc-3-pub-subnet"
  }
}
resource "aws_subnet" "vpc_3_public_subnet_a" {
  vpc_id            = aws_vpc.vpc_3.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_3.cidr_block, 8, 2)
  availability_zone = "${var.AWS_DEFAULT_REGION}a"
  tags = {
    Name = "${var.environment}-vpc-3-pub-subnet-a"
  }
}
resource "aws_subnet" "vpc_3_private_subnet" {
  vpc_id            = aws_vpc.vpc_3.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_3.cidr_block, 8, 1)
  availability_zone = "${var.AWS_DEFAULT_REGION}b" # Should be same as other Subnet that have NAT GW
  tags = {
    Name = "${var.environment}-vpc-3-private-subnet"
  }
}

resource "aws_subnet" "vpc_3_private_subnet_a" {
  vpc_id            = aws_vpc.vpc_3.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_3.cidr_block, 8, 3)
  availability_zone = "${var.AWS_DEFAULT_REGION}a" # Should be same as other Subnet that have NAT GW
  tags = {
    Name = "${var.environment}-vpc-3-private-subnet_a"
  }
}
