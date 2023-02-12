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
    target_group_arn = aws_alb_target_group.test.id
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