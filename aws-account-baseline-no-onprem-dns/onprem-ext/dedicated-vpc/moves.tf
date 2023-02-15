moved {
  from = aws_vpc_ipam_pool_cidr_allocation.frontend
  to = module.frontend_allocation.aws_vpc_ipam_pool_cidr_allocation.full
}

moved {
  from = aws_vpc_ipam_pool_cidr_allocation.backend
  to = module.backend_allocation.aws_vpc_ipam_pool_cidr_allocation.full
}

moved {
  from = aws_subnet.frontend["eu-west-1a"]
  to = aws_subnet.frontend["0_eu-west-1a"]
}

moved {
  from = aws_subnet.frontend["eu-west-1b"]
  to = aws_subnet.frontend["0_eu-west-1b"]
}

moved {
  from = aws_route_table_association.frontend["eu-west-1a"]
  to = aws_route_table_association.frontend["0_eu-west-1a"]
}

moved {
  from = aws_route_table_association.frontend["eu-west-1b"]
  to = aws_route_table_association.frontend["0_eu-west-1b"]
}

