# output "acm_validation_fqdn" {
#     value = aws_route53_record.acm_validation.fqdn
# }

output "route53_hosted_zone_id" {
    value = data.aws_route53_zone.zone.id
}