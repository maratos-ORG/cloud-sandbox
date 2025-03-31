locals {
  vpc_id = var.vpc_id != "" ? var.vpc_id : null
}

resource "aws_vpc" "rds_vpc" {
  count                = local.vpc_id == null ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = "${var.location_name}-${var.env_name["short"]}-rds-vpc"
    },
  )
}

resource "aws_internet_gateway" "igw" {
  count = var.enable_public_access && local.vpc_id == null ? 1 : 0
  vpc_id = local.vpc_id != null ? local.vpc_id : aws_vpc.rds_vpc[0].id

  tags = merge(
    var.tags,
    {
      Name = "${var.location_name}-${var.env_name["short"]}-igw"
    }
  )
}

resource "aws_route_table" "public" {
  count = var.enable_public_access && local.vpc_id == null ? 1 : 0
  vpc_id = local.vpc_id != null ? local.vpc_id : aws_vpc.rds_vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.location_name}-${var.env_name["short"]}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public_subnets" {
  count = var.enable_public_access && local.vpc_id == null ? length(var.availability_zones) : 0
  subnet_id = element(aws_subnet.rds_private_subnets[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_subnet" "rds_private_subnets" {
  count = length(var.availability_zones)

  vpc_id            = local.vpc_id != null ? local.vpc_id : aws_vpc.rds_vpc[0].id
  cidr_block = length(var.subnet_cidrs) > 0 ? var.subnet_cidrs[count.index] : cidrsubnet(var.vpc_cidr, 28, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    var.tags,
    {
      Name = format("%s-%s-subnet %s", var.location_name, var.env_name["short"], element(var.availability_zones, count.index))
    },
  )
}