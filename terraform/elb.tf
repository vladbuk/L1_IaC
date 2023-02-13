resource "aws_alb" "alb" {
  name            = "test-alb"
  load_balancer_type = "application"
  subnets         = [ aws_subnet.subnet1.id, aws_subnet.subnet2.id ]
  security_groups = [ aws_security_group.allow_ports.id ]
  internal        = false
  tags = {
    Name = "test-alb"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    target_group_arn = aws_alb_target_group.test.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = [ aws_alb_target_group.test ]
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.test.arn
  }   
  condition {
    host_header {
      values = ["test.vladbuk.site"]
    }
  }
}

resource "aws_alb_target_group" "test" {
  name     = "test"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  tags = {
    name = "test"
  }   
}

resource "aws_alb_target_group_attachment" "test" {
  target_group_arn = aws_alb_target_group.test.arn
  target_id        = aws_instance.t2micro_ubuntu_test.id
  port             = 8080
}



# https listener

# resource "aws_acm_certificate" "test_cert" {
#   domain_name       = "test.vladbuk.site"
#   validation_method = "DNS"

#   tags = {
#     name = "test-cert"
#   }
# }

resource "aws_alb_listener" "alb_https_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn = "arn:aws:acm:eu-central-1:054889260026:certificate/c4d4b5f1-b623-43fb-aed4-761d6d294897"
  
  default_action {
    target_group_arn = aws_alb_target_group.test.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "https_listener_rule" {
  depends_on   = [ aws_alb_target_group.test ]
  listener_arn = aws_alb_listener.alb_https_listener.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.test.arn
  }   
  condition {
    host_header {
      values = ["test.vladbuk.site"]
    }
  }
}

# resource "aws_alb_target_group" "https_test" {
#   name     = "https-test"
#   port     = "443"
#   protocol = "HTTPS"
#   vpc_id   = aws_vpc.main_vpc.id
#   tags = {
#     name = "https-test"
#   }   
# }

# resource "aws_alb_target_group_attachment" "https_test" {
#   target_group_arn = aws_alb_target_group.https_test.arn
#   target_id        = aws_instance.t2micro_ubuntu_test.id
#   port             = 8080
# }
