# EC2 Configurations in ASG
resource "aws_launch_template" "ec2s_app" {
  name_prefix   = "app-launch-template"
  image_id      = "ami-0182f373e66f89c85"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.private_key_ec2s_pair.key_name
  network_interfaces {
    security_groups = [aws_security_group.vpc_1_security_group.id]
  }

  user_data = base64encode(<<-EOF
        sudo yum install git -y
        git clone https://github.com/omartamer630/Highly_available_Design_deployment.git
        cd Highly_available_Design_deployment/app/
        sudo bash prerequisites.sh
        sudo python3 app.py
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
  vpc_zone_identifier = [aws_subnet.vpc_1_private_subnet_asg_a.id, aws_subnet.vpc_1_private_subnet_asg_b.id]
  tag {
    key                 = "Name"
    value               = "ASG_instance"
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [desired_capacity] # ignores any manual and automated change in ASG
  }
}
