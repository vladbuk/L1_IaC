data "aws_route53_zone" "selected" {
  name         = "vladbuk.site."
  private_zone = false
}

resource "aws_route53_record" "testip" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "testip.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = 600
  records = [aws_instance.t2micro_ubuntu_test.public_ip]
}

resource "aws_route53_record" "test" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "test.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = 600
  records = [ aws_alb.alb.dns_name ]
}

resource "aws_route53_record" "prod1ip" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "prod1ip.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = 600
  records = [aws_instance.t2micro_ubuntu_prod_1.public_ip]
}

resource "aws_route53_record" "prod2ip" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "prod2ip.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = 600
  records = [aws_instance.t2micro_ubuntu_prod_2.public_ip]
}

resource "aws_route53_record" "prod" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${data.aws_route53_zone.selected.name}"
  type    = "A"
  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www-prod" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = 600
  records = [ aws_alb.alb.dns_name ]
}
