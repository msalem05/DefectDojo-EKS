variable "cluster_name" {
  type    = string
  default = "defectdojo-eks"
}

variable "cluster_role_arn" {
  type = string
}

variable "k8s_version" {
  type    = string
  default = "1.36"
}

variable "subnet_id" {
  type = list(string)
}

variable "eks_admin_role_name" {
  type    = string
  default = "defectdojo-eks-admin"
}

variable "platform_team_role_arn" {
  type    = string
  default = "arn:aws:iam::622703418024:user/ASUS-Terminal"
}

variable "node_role_arn" {
  type = string
}

variable "node_group_name" {
  type    = string
  default = "defectdojo-node-group"
}

variable "desired_size" {
  type    = number
  default = 3
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 5
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "vpc_cni_role_arn" {
  type = string
}

variable "ebs_csi_role_arn" {
  type = string
}

variable "eso_role_arn" {
  type = string
}

variable "lb_controller_arn" {
  type = string
}

variable "cert_manager_role_arn" {
  type = string
}