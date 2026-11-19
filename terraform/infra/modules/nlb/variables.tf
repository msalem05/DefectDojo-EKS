variable "nlb_name" {
  type    = string
  default = "defectdojo-nlb"
}

variable "subnet_ids" {
  type = list(string)
}

variable "nlb_sg_id" {
  type = string
}

variable "tg_name" {
  type    = string
  default = "defectdojo-tg"
}

variable "vpc_id" {
  type = string
}

variable "healthy_threshold" {
  type    = number
  default = 3
}

variable "unhealthy_threshold" {
  type    = number
  default = 3
}

variable "interval" {
  type    = number
  default = 30
}

variable "timeout" {
  type    = number
  default = 5
}

variable "matcher" {
  type    = string
  default = "200-399"
}

variable "nlb_http_tg_name" {
  type = string 
  default = "defectdojo-http-tg"
}