variable "domain_name" {
  type    = string
  default = "ddojo-sec.com"
}

variable "nlb_dns_name" {
  type = string
}

variable "nlb_zone_id" {
  type = string
}

# variable "acm_validation_name" {
#   type = string
# }

# variable "acm_validation_record" {
#   type = list(string)
# }

variable "ttl" {
  type    = number
  default = 300
}
