resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

}

resource "aws_default_security_group" "main_sg" {
  vpc_id = aws_vpc.main.id

  ingress = []
  egress  = []

  tags = {
    Name = "default-sg-deny-all"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.az)
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = false

}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.az)
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.az[count.index]

}

resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_route.public_route]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_association" {
  count          = length(var.az)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_association" {
  count          = length(var.az)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}

# Security Groups

resource "aws_security_group" "nlb" {
  name   = var.nlb_sg_name
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "nlb_ingress_https" {
  type              = "ingress"
  security_group_id = aws_security_group.nlb.id
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
}

resource "aws_security_group_rule" "nlb_egress_envoy" {
  type              = "egress"
  security_group_id = aws_security_group.nlb.id
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [var.vpc_cidr]
  protocol          = "tcp"
}

resource "aws_security_group" "eks_node" {
  name   = var.eks_node_sg_name
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "eks_nodes_egress_https" {
  type              = "egress"
  security_group_id = aws_security_group.eks_node.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group_rule" "db_egress" {
  type              = "egress"
  security_group_id = aws_security_group.eks_node.id
  from_port         = "5432"
  to_port           = "5432"
  cidr_blocks       = [var.vpc_cidr]
  protocol          = "tcp"
}

resource "aws_security_group_rule" "eks_node_egress_valkey" {
  type              = "egress"
  security_group_id = aws_security_group.eks_node.id
  from_port         = "6379"
  to_port           = "6379"
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group_rule" "eks_node_dns_egress" {
  type              = "egress"
  security_group_id = aws_security_group.eks_node.id
  from_port         = "53"
  to_port           = "53"
  protocol          = "udp"
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group_rule" "eks_node_dns_egress_tcp" {
  type              = "egress"
  security_group_id = aws_security_group.eks_node.id
  from_port         = "53"
  to_port           = "53"
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group" "db_sg" {
  name   = var.db_sg_name
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "eks_node_db_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.db_sg.id
  from_port                = var.db_port
  to_port                  = var.db_port
  source_security_group_id = aws_security_group.eks_node.id
  protocol                 = "tcp"
}

resource "aws_security_group" "valkey_sg" {
  name   = var.valkey_sg_name
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "eks_node_valkey_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.valkey_sg.id
  from_port                = var.valkey_port
  to_port                  = var.valkey_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_node.id
}
