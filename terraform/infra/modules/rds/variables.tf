variable "minimum_storage" {
  description = "Minimum storage for DB Storage Autoscaling"
  type        = number
  default     = 50
}

variable "maximum_storage" {
  description = "Maximum storage for DB Storage Autoscaling"
  type        = number
  default     = 200
}

variable "db_name" {
  type    = string
  default = "defectdojodb"
}

variable "instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "maintenance_window" {
  type    = string
  default = "Fri:09:00-Fri:09:30"
}

variable "snapshot_identifier" {
  type    = string
  default = "url-shortener-db-snapshot"
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "subnet_group_name" {
  type    = string
  default = "private-subnets"
}

variable "subnet_ids" {
  description = "ID of Private Subnets"
  type        = list(any)
}

variable "db_engine_version" {
  type    = string
  default = "18.1"
}

variable "cloudwatch_exports" {
  type    = list(string)
  default = ["postgresql", "upgrade"]
}

variable "db_sg_id" {
  type = string
}

variable "final_snapshot" {
  type    = string
  default = "url-shortener-final-snapshot"
}