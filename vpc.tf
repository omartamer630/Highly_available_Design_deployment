# VPC_1 Creation
resource "aws_vpc" "vpc_1" {
  cidr_block           = var.cidr[0].cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.environment}-vpc-1"
  }
}

# VPC_2 Creation

resource "aws_vpc" "vpc_2" {
  cidr_block           = var.cidr[1].cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.environment}-vpc-2"
  }
}

# VPC_3 Creation

resource "aws_vpc" "vpc_3" {
  cidr_block           = var.cidr[2].cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.environment}-vpc-3"
  }
}
