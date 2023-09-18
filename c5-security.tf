resource "aws_security_group" "ec2_eg1" {
  name   = "ec2-eg1"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "alb_eg1" {
  name   = "alb-eg1"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress_ec2_traffic" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_eg1.id
  source_security_group_id = aws_security_group.alb_eg1.id
}

resource "aws_security_group_rule" "ingress_ec2_health_check" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_eg1.id
  source_security_group_id = aws_security_group.alb_eg1.id
}

resource "aws_security_group_rule" "full_egress_ec2" {
   type              = "egress"
   from_port         = 0
   to_port           = 0
   protocol          = "-1"
   security_group_id = aws_security_group.ec2_eg1.id
   cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_alb_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_eg1.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_alb_traffic" {
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_eg1.id
  source_security_group_id = aws_security_group.ec2_eg1.id
}

resource "aws_security_group_rule" "egress_alb_health_check" {
  type                     = "egress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_eg1.id
  source_security_group_id = aws_security_group.ec2_eg1.id
}



