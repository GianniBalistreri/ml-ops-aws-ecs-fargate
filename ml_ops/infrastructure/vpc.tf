resource "aws_vpc" "ecs_vpc" { 
  cidr_block = var.ecs_vpc_cidr_block
  enable_dns_hostnames = var.ecs_enable_dns_hostnames
}