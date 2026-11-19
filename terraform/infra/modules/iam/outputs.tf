output "vpc_cni_role_arn" {
  value = aws_iam_role.vpc_cni.arn
}

output "eso_role_arn" {
  value = aws_iam_role.eso.arn
}

output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "ebs_csi_role_arn" {
  value = aws_iam_role.ebs_csi.arn
}

output "node_role_arn" {
  value = aws_iam_role.eks_node.arn
}

output "lb_controller_role_arn" {
  value = aws_iam_role.aws_lb_controller.arn
}

output "cert_manager_role_arn" {
  value = aws_iam_role.cert_manager.arn
}