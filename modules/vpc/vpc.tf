resource "aws_vpc" "mainVpc" {
    cidr_block = var.cidr_block_vpc

    tags = {
        Name = "MainVPC"
    }
}

resource "aws_internet_gateway" "igw"{
  vpc_id = aws_vpc.mainVpc.id

  tags = {
    Name = "MainIGW"
  }
}

resource "aws_subnet" "publicSubnets" {
  for_each = var.publicSubnets
    vpc_id            = aws_vpc.mainVpc.id
    cidr_block        = each.value.cidr_block
    availability_zone = each.value.availability_zone
    tags              = each.value["tags"]
}

resource "aws_subnet" "privateSubnets" {
  for_each = var.privateSubnets
    vpc_id            = aws_vpc.mainVpc.id
    cidr_block        = each.value.cidr_block
    availability_zone = each.value.availability_zone
    tags              = each.value["tags"]
}

resource "aws_eip" "nat_eip" {
  vpc        = true

  tags = {
    Name = "NATGatewayEIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.publicSubnets["Public1"].id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "NATGateway"
  }
}

resource "aws_route_table" "public" {
  for_each = var.publicRouteTable 
  vpc_id = aws_vpc.mainVpc.id

  dynamic "route" {
    for_each = var.publicRouteTable
  content {
    cidr_block = var.default_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }
  }

  tags = {
    Name = "publicRouteTable"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.publicSubnets["Public1"].id
  route_table_id = aws_route_table.public["Public1"].id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.publicSubnets["Public2"].id
  route_table_id = aws_route_table.public["Public2"].id
}

resource "aws_route_table" "private" {
  for_each = var.privateRouteTable 
  vpc_id = aws_vpc.mainVpc.id

  dynamic "route" {
    for_each = var.privateRouteTable
  content {
    cidr_block = var.default_cidr_block
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  }

  tags = {
    Name = "privateRouteTable"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.privateSubnets["Private1"].id
  route_table_id = aws_route_table.private["Private1"].id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.privateSubnets["Private2"].id
  route_table_id = aws_route_table.private["Private2"].id
}