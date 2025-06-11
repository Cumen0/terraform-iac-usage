resource "aws_eip" "cyber_ip" {
    instance = aws_instance.cyber_server.id
    tags = {
        Name = "Cyber Elastic IP"
    }
}

resource "aws_instance" "cyber_server" {
    ami           = data.aws_ami.latest_ubuntu.id
    key_name      = var.key_name
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.cyber_sg.id]
    tags = {
        Name = "Cyber Server"
    }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.key_path)
      host        = aws_instance.cyber_server.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.cyber_server.public_ip}, --private-key ${var.key_path} nginx-playbook.yaml"
  }

  depends_on = [aws_security_group.cyber_sg]
}


resource "aws_security_group" "cyber_sg" {
  name        = "Cyber Server Security Group"
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
    Name = "Cyber Security Group"
  }
}