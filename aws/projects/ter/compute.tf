resource "aws_acm_certificate" "cert" {
  domain_name       = var.hosted_zone_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = var.env
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_acm_certificate.cert.domain_validation_options : record.resource_record_name]
}

resource "aws_route53_record" "cyber_dns" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.hosted_zone_name
  type    = "A"

  alias {
    name                   = aws_lb.cyber_lb.dns_name
    zone_id               = aws_lb.cyber_lb.zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_acm_certificate_validation.cert_validation]
}

resource "aws_launch_template" "cyber_server_lt" {
  image_id      = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = filebase64("${path.module}/scripts/bootstrapping.sh")

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.cyber_lb_sg.id]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name = "${var.env}-instance-lt"
  }
}

resource "aws_lb" "cyber_lb" {
  name               = "cyber-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cyber_lb_sg.id]
  subnets            = data.aws_subnets.subnets.ids

  tags = {
    Name = "Cyber Load Balancer"
  }
}

resource "aws_lb_target_group" "cyber_tg" {
  name     = "cyber-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_listener" "cyber_listener" {
  load_balancer_arn = aws_lb.cyber_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cyber_tg.arn
  }
}

resource "aws_autoscaling_group" "instance_asg" {
  vpc_zone_identifier = data.aws_subnets.subnets.ids
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2

  launch_template {
    id      = aws_launch_template.cyber_server_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.cyber_tg.arn]
}

resource "aws_security_group" "cyber_lb_sg" {
  name        = "Cyber Load Balancer Security Group"
  description = "Security group for the load balancer"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Cyber Load Balancer Security Group"
  }
}