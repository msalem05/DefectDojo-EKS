variable "cluster_role_name" {
  type    = string
  default = "defectdojo-eks-cluster-role"
}

variable "eks_node_role_name" {
  type    = string
  default = "defectdojo-eks-node-role"
}

variable "vpc_cni_role_name" {
  type    = string
  default = "defectdojo-vpc-cni-role"
}

variable "ebs_csi_role_name" {
  type    = string
  default = "defectdojo-ebs-csi-role"
}

variable "eso_role_name" {
  type    = string
  default = "defectdojo-eso-role"
}

variable "valkey_endpoint_arn" {
  type = string
}

variable "lb_controller_role_name" {
  type    = string
  default = "defectdojo-aws-lb-controller"
}

variable "lb_controller_policy" {
  type    = string
  default = "defectdojo-aws-lb-controller-policy"
}

variable "route53_hosted_zone_id" {
  type = string
}