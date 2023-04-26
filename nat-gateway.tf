resource "aws_eip" "nat_gw_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gw_ip.id
  subnet_id     = aws_subnet.boundary_ingress_worker_subnet.id

  tags = {
    Name = "Boundary Demo NAT GW"
  }

  depends_on = [aws_internet_gateway.boundary_ingress_worker_ig]
}

