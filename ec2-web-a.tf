data "aws_ami" "amazon-linux-2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }
}

resource "aws_instance" "server-1" {
  ami           = data.aws_ami.amazon-linux-2023.id
  instance_type = var.ec2_instance_type

  subnet_id = var.pri_subnet_id_a

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

user_data_replace_on_change = true
  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  echo "Hello World from $(hostname -f)" > /var/www/html/index.html

EOF

  vpc_security_group_ids = [aws_security_group.web-server-sg.id]
  iam_instance_profile = "role-terraform-lab-instance-core"

  tags = {
    Name = "ec2-${var.owner}-webserver-a"
  }
}

resource "aws_security_group" "web-server-sg" {
  name = "securitygroup-${var.owner}-web-server"
  description = "Web Server Security Group"
  vpc_id = var.vpc_id

  tags = {
    Name = "securitygroup-${var.owner}-web-server"
  }
}

resource "aws_security_group_rule" "http_80" {
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.web-server-sg.id
  type              = "ingress"
  source_security_group_id = aws_security_group.alb_public_web_sg.id
}

resource "aws_security_group_rule" "ec2egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.web-server-sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}