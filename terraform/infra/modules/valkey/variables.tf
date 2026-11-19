variable "replication_group_id" {
  type    = string
  default = "defectdojo-valkey"
}

variable "node_type" {
  type    = string
  default = "cache.t4g.micro"
}

variable "num_cache_clusters" {
  type    = number
  default = 1
}

variable "valkey_sg_id" {
  type = string
}

variable "private_subnet_id" {
  type = list(string)
}

variable "subnet_group_name" {
  type    = string
  default = "valkey-subnet-group"
}