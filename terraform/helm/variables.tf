variable "aws_region" {
  type        = string
  default     = "eu-west-2"
}

variable "cluster_name" {
  type        = string
  default     = "defectdojo-eks"
}

variable "eks_admin_role_arn" {
  type        = string
  default = "arn:aws:iam::622703418024:role/defectdojo-eks-admin"
}

variable "cluster_name" {
  type        = string
}

variable "aws_region" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "http_tg_arn" {
  type        = string
}

variable "https_tg_arn" {
  type        = string
}