resource "aws_db_instance" "mysql" {
  identifier             = "roboshop-mysql-${var.ENV}"
  allocated_storage      = var.RDS_MYSQL_STORAGE
  engine                 = "mysql"
  engine_version         = var.RDS_ENGINE_VERSION
  instance_class         = var.RDS_INSTANCE_TYPE
  username               = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["RDS_MYSQL_USERNAME"]
  password               = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["RDS_MYSQL_PASSWORD"]
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.mysql.id]
}

resource "aws_db_subnet_group" "mysql" {
    name       = "roboshop-mysql-${var.ENV}"
    subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_parameter_group" "mysql" {
  name   = "roboshop-mysql-${var.ENV}"
  family = "mysql${var.RDS_ENGINE_VERSION}"
}

resource "aws_security_group" "mysql" {
  name        = "roboshop-mysql-${var.ENV}"
  description = "roboshop-mysql-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "Allows MySQL Port"
    from_port   = var.RDS_MYSQL_PORT
    to_port     = var.RDS_MYSQL_PORT
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, var.WORKSTATION_IP]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, var.WORKSTATION_IP]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name =  "roboshop-redis-sg-${var.ENV}"
  }
}








