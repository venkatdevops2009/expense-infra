resource "aws_instance" "database" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.database.id]
  user_data              = file("${path.module}/scripts/database-setup.sh")

  tags = {
    Name = "database"
  }
}

resource "aws_instance" "backend" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.backend.id]

  user_data = templatefile("${path.module}/scripts/backend-setup.sh", {
    DB_HOST = aws_instance.database.private_ip
  })

  depends_on = [aws_instance.database]

  tags = {
    Name = "backend"
  }
}

resource "aws_instance" "frontend" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.frontend.id]

  user_data = templatefile("${path.module}/scripts/frontend-setup.sh", {
    BACKEND_HOST = aws_instance.backend.private_ip
  })

  depends_on = [aws_instance.backend]

  tags = {
    Name = "frontend"
  }
}