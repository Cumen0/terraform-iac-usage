resource "aws_instance" "cyber_server" {
    ami           = data.aws_ami.latest_ubuntu.id
    key_name      = var.key_name
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.cyber_sg.id]
    tags = {
        Name = "Server"
    }
  depends_on = [aws_security_group.cyber_sg]
}

resource "aws_security_group" "cyber_sg" {
  name        = "Security Group"
  description = "Allow SSH, HTTP and HTTPS inbound traffic"
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
    Name = "Security Group"
  }
}