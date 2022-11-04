resource "aws_alb" "LB" {
  name               = "loadBalancer"
  internal           = false
  load_balancer_type = "application"
  # security_groups    = [aws_security_group.TerraformEc2Security.id]
  subnets            = var.publicSubnet

  tags = {
    Name = "ujs"
  }
}

resource "aws_alb_target_group" "targetGroupTreti" {
  name     = "targetGroupTreti"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpcId

  health_check {
    matcher = "200"
    interval = "20"
    protocol = "HTTP"
    timeout = "2"
    path = "/"
    unhealthy_threshold = "2"
    healthy_threshold = "3"
  }
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.LB.id
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.targetGroupTreti.id
    type             = "forward"
  }
}