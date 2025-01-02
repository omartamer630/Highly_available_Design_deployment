resource "aws_lb" "alb_to_asg_ec2" {
  name                       = "alb-configuration"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.vpc_3_security_group.id]
  subnets                    = [aws_subnet.vpc_3_private_subnet.id, aws_subnet.vpc_3_public_subnet.id]
  enable_deletion_protection = false

  tags = {
    Name = "${var.environment}-alb"
  }
}

# Create Target Group
resource "aws_lb_target_group" "alb_groups" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_1.id

  health_check {
    port     = 80
    protocol = "HTTP"
    path     = "/"
  }

  tags = {
    Name = "${var.environment}-alb"
  }
}

# Create Listener for ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb_to_asg_ec2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_groups.arn
  }
}
