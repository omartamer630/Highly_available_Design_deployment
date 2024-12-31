# EC2 Configurations in ASG
resource "aws_launch_template" "ec2s_app" {
  name_prefix   = "app-launch-template"
  image_id      = "ami-0182f373e66f89c85"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.private_key_ec2s_pair.key_name
  network_interfaces {
    security_groups = [aws_security_group.forgtech_ec2_sg_vpc_2.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3
              echo "Hello, World from ASG" > /home/ec2-user/index.html
              cd /home/ec2-user
              python3 -m http.server 80 &
              EOF
  )
}

resource "aws_autoscaling_group" "asg_private_subnets" {
  launch_template {
    id      = aws_launch_template.ec2s_app.id
    version = "$Latest"
  }
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.vpc_1_private_subnet.id, aws_subnet.vpc_2_private_subnet.id]
  tag {
    key                 = "Name"
    value               = "ASG_instance"
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [desired_capacity] # ignores any manual and automated change in ASG
  }
}
