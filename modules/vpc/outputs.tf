output "vpcId" {
    value = aws_vpc.mainVpc.id
}

output "igw" {
    value = aws_internet_gateway.igw.id
}

output "publicSubnet" {
    value = [aws_subnet.publicSubnets["Public1"].id, aws_subnet.publicSubnets["Public2"].id]
}

output "privateSubnet" {
    value = [aws_subnet.privateSubnets["Private1"].id, aws_subnet.privateSubnets["Private2"].id]
}

output "region" {
    value = "eu-central-1"
}