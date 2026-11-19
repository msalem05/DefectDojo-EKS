data "aws_route53_zone" "zone" {
  name = "ddojo-sec.com"
}

resource "aws_route53_record" "alb_dns" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.nlb_dns_name
    zone_id                = var.nlb_zone_id
    evaluate_target_health = true
  }
}

# resource "aws_route53_record" "acm_validation" {
#   zone_id         = data.aws_route53_zone.zone.zone_id
#   name            = var.acm_validation_name
#   records         = var.acm_validation_record
#   type            = "CNAME"
#   allow_overwrite = true
#   ttl             = var.ttl
# }
