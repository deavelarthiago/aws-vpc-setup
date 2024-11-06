data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    environment = var.environment,
    Name        = "vpc-for-${var.environment}-environment"
  }
}

#Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    environment = var.environment,
    Name        = "${var.environment}-internet-gateway"
  }
}

#Create Public Subnets for each AZ
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-${element(data.aws_availability_zones.available.names, count.index)}",
    AZ          = element(data.aws_availability_zones.available.names, count.index),
    environment = var.environment,
    tier        = "Public"
  }
}

#Create Private Subnets for each AZ
resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "private-subnet-${element(data.aws_availability_zones.available.names, count.index)}",
    AZ          = element(data.aws_availability_zones.available.names, count.index),
    environment = var.environment,
    tier        = "Private"
  }
}

#Associate the Internet Gateway to our route to allow external traffic
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    description = "Public route table",
    environment = var.environment,
    Name        = "${var.environment}-public-route-table"
  }
}

#Associate the Public Subnet to the Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route_table.public]
}

#Create Route Table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    environment = var.environment,
    Name        = "${var.environment}-private-route-table"
  }
}

#Associate the Private Subnet to the Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
