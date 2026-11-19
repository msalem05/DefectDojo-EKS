output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private[*].id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

output "eks_node_sg_id" {
  value = aws_security_group.eks_node.id
}

output "valkey_sg_id" {
  value = aws_security_group.valkey_sg.id
}

output "nlb_sg_id" {
  value = aws_security_group.nlb.id
}
