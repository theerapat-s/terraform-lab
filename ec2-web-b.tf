resource "aws_instance" "server-2" {
  ami           = data.aws_ami.amazon-linux-2023.id
  instance_type = var.ec2_instance_type

  subnet_id = var.pri_subnet_id_b

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
    Name = "ec2-${var.owner}-webserver-b"
  }
}