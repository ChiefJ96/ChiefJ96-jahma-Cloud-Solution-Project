// modules/vpc/main.tf
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name        = var.name
    Environment = var.environment
  })
}

resource "aws_subnet" "public" {
  for_each = { for k, v in var.subnets : k => v if v.type == "public" }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name        = each.key
    Environment = var.environment
    Tier        = "Public"
  })
}

resource "aws_subnet" "private" {
  for_each = { for k, v in var.subnets : k => v if v.type == "private" }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name        = each.key
    Environment = var.environment
    Tier        = "Private"
  })
}

# Internet Gateway for public internet access
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name        = "${var.name}-igw"
    Environment = var.environment
  })
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name        = "${var.name}-public-rt"
    Environment = var.environment
    Tier        = "Public"
  })
}

# Route table associations for public subnets
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Route table for private subnets (no internet access)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name        = "${var.name}-private-rt"
    Environment = var.environment
    Tier        = "Private"
  })
}

# Route table associations for private subnets
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}