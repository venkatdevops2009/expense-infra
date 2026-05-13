resource "aws_route53_record" "frontend" {
  zone_id = var.zone_id
  name    = "piridishop.shop"
  type    = "A"
  ttl     = 1
  records = [aws_instance.frontend.public_ip]
}

resource "aws_route53_record" "backend" {
  zone_id = var.zone_id
  name    = "backend.piridishop.shop"
  type    = "A"
  ttl     = 1
  records = [aws_instance.backend.private_ip]
}

resource "aws_route53_record" "database" {
  zone_id = var.zone_id
  name    = "database.piridishop.shop"
  type    = "A"
  ttl     = 1
  records = [aws_instance.database.private_ip]
}