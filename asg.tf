# EC2 Configurations in ASG
resource "aws_launch_template" "nginx_proxy" {
  name_prefix   = "app-launch-template"
  image_id      = "ami-0182f373e66f89c85"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.private_key_ec2s_pair.key_name
  network_interfaces {
    security_groups = [aws_security_group.vpc_3_security_group.id]
  }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      sudo yum update -y
      sudo yum install -y nginx

      # Start and enable Nginx service
      sudo systemctl start nginx
      sudo systemctl enable nginx

      # Add server_names_hash_bucket_size to nginx.conf
      echo 'server_names_hash_bucket_size 128;' | sudo tee -a /etc/nginx/nginx.conf

      # Configure Nginx proxy settings
      echo 'server {
          listen 80;

          server_name ${aws_lb.public_lb.dns_name}:80; # Replace with your actual public-facing ALB DNS

          location / {
              proxy_pass http://${aws_lb.internal_lb.dns_name};  # Internal ALB DNS name or NLB
              proxy_set_header Host \$host;
              proxy_set_header X-Real-IP \$remote_addr;
              proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto \$scheme;
          }
      }' | sudo tee /etc/nginx/conf.d/proxy.conf

      # Test Nginx configuration and reload
      sudo nginx -t
      sudo systemctl reload nginx

      EOF
  )
}

resource "aws_autoscaling_group" "asg_for_proxy_servers" {
  launch_template {
    id      = aws_launch_template.nginx_proxy.id
    version = "$Latest"
  }
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.vpc_3_private_subnet.id, aws_subnet.vpc_3_private_subnet_a.id]
  target_group_arns   = [aws_lb_target_group.nginx_target_group.id]
  tag {
    key                 = "Name"
    value               = "ASG_NGNINX_instance"
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [desired_capacity] # ignores any manual and automated change in ASG
  }
}

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
      sudo yum install git
      git clone https://github.com/omartamer630/Highly_available_Design_deployment.git
      cd Highly_available_Design_deployment/app/
      sudo bash prerequisites.sh
      nohup sudo python3 app.py > app.log 2>&1 &

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
  target_group_arns   = [aws_lb_target_group.internal_tg.arn]
  tag {
    key                 = "Name"
    value               = "ASG_instance"
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [desired_capacity] # ignores any manual and automated change in ASG
  }
}
