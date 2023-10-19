resource "aws_lb" "test" {
  name               = "tf-elb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id, aws_subnet.public_subnets[2].id]


  tags = {
    Name = "TF_ELB"
  }
}

resource "aws_lb_target_group" "test" {
  target_type = "instance"
  name        = "tf-elb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "test" {
  count            = length(var.subnet-cidrs)
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.test[count.index].id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}