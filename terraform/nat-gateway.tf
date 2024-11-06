resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"

  tags = {
    Environment = var.environment,
    Name        = "NAT Gateway EIP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = tolist(aws_subnet.public.*.id)[0]

  tags = {
    Environment = var.environment,
    Name        = "${var.environment} NAT Gateway"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}
