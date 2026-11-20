resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.k8s_version

  access_config {
    authentication_mode = "API"
  }

  vpc_config {
    subnet_ids = var.subnet_id
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
}

resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.cluster.name
  principal_arn = aws_iam_role.eks_admin.arn
}

resource "aws_iam_role" "eks_admin" {
  name = var.eks_admin_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = var.platform_team_role_arn
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.cluster.name
  principal_arn = aws_iam_role.eks_admin.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin]
}

# Addons

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "eks-pod-identity-agent"
}

resource "aws_eks_node_group" "bootstrap" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_role_arn   = var.node_role_arn
  node_group_name = var.node_group_name
  subnet_ids      = var.subnet_id

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }
}

# EKS Pod Identities

resource "aws_eks_pod_identity_association" "vpc_cni" {
  cluster_name    = aws_eks_cluster.cluster.name
  namespace       = var.namespace
  role_arn        = var.vpc_cni_role_arn
  service_account = "aws-node"

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]
}

resource "aws_eks_pod_identity_association" "eso" {
  cluster_name    = aws_eks_cluster.cluster.name
  namespace       = "external-secrets"
  role_arn        = var.eso_role_arn
  service_account = "external-secrets"

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]
}

resource "aws_eks_pod_identity_association" "aws_load_balancer_controller" {
  cluster_name    = aws_eks_cluster.cluster.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = var.lb_controller_arn

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]
}

resource "aws_eks_pod_identity_association" "cert_manager" {
  cluster_name    = aws_eks_cluster.cluster.name
  namespace       = "cert-manager"
  service_account = "cert-manager"
  role_arn        = var.cert_manager_role_arn

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]
}