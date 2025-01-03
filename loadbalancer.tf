# Internal Load Balancer for VPC 1
resource "aws_lb" "internal_lb" {
  name                       = "dev-internal-alb"
  internal                   = true
  load_balancer_type         = "network"
  security_groups            = [aws_security_group.vpc_1_security_group.id]
  subnets                    = [aws_subnet.vpc_1_private_subnet_asg_a.id, aws_subnet.vpc_1_private_subnet_asg_b.id]
  enable_deletion_protection = false

  tags = {
    Name = "${var.environment}-internal"
  }
}

resource "aws_lb_target_group" "internal_tg" {
  name        = "internal-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc_1.id
  target_type = "instance"

  health_check {
    port     = 80
    protocol = "HTTP"
    path     = "/"
  }

  tags = {
    Name = "${var.environment}-internal-tg"
  }
}

resource "aws_lb_listener" "internal_listener" {
  load_balancer_arn = aws_lb.internal_lb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_tg.arn
  }
}

# Public Load Balancer

resource "aws_lb" "public_lb" {
  name                       = "public-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.vpc_3_security_group.id]
  subnets                    = [aws_subnet.vpc_3_public_subnet.id, aws_subnet.vpc_3_public_subnet_a.id]
  enable_deletion_protection = false

}

resource "aws_lb_target_group" "nginx_target_group" {
  name        = "nginx-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_3.id
  target_type = "instance"
  health_check {
    protocol = "HTTP"
    port     = 80
    path     = "/"
  }
}

resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}


resource "aws_lb_target_group_attachment" "nginx_attachment" {
  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = aws_instance.bastion_host.id # The EC2 instance running Nginx
  port             = 80
}
