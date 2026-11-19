variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "az" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "private_subnet_cidr" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "nlb_sg_name" {
  type    = string
  default = "defectdojo-nlb-sg"
}

variable "uwsgi_eks_sg_name" {
  type    = string
  default = "defectdojo-uwsgi-eks-sg"
}

variable "celery_worker_eks_sg_name" {
  type    = string
  default = "defectdojo-celery-worker-eks-sg"
}

variable "celery_beat_eks_sg_name" {
  type    = string
  default = "defectdojo-celery-beat-eks-sg"
}

variable "db_sg_name" {
  type    = string
  default = "defectdojo-db-sg"
}

variable "uwsgi_port" {
  type    = number
  default = 8081
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "valkey_port" {
  type    = number
  default = 6379
}

variable "valkey_sg_name" {
  type    = string
  default = "defectdojo-valkey-sg"
}

variable "eks_node_sg_name" {
  type    = string
  default = "defectdojo-eks-node-sg"
}