resource "aws_vpc_endpoint" "fw_endpoint" {
  provider = aws.app
  for_each = toset(var.availability_zones)

  service_name      = var.fw_eps_name
  subnet_ids        = [aws_subnet.firewall[each.value].id]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = aws_vpc.standalone.id

  tags = {
    Name = "ep-${var.name}-fw-${aws_subnet.firewall[each.value].availability_zone}"
  }
}
