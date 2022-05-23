resource "aws_db_instance" "mysql" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin1"
  password             = "RoboShop1"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  aws_db_subnet_group  = aws_db_subnet_group.mysql.name
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
  family = "mysql5.7"
}

resource "aws_security_group" "mysql" {
  name        = "roboshop-mysql-${var.ENV}"
  description = "roboshop-mysql-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "Allows MySQL Port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }
  ingress {
    description = "Allows Def Subnet CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
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








#resource "aws_elasticache_cluster" "redis" {
#  cluster_id           = "roboshop-${var.ENV}"
#  engine               = "redis"
#  node_type            = "cache.t3.small"
#  num_cache_nodes      = 1
#  parameter_group_name = aws_elasticache_parameter_group.default.name
#  engine_version       = "6.x"
#  port                 = 6379
#  subnet_group_name    = aws_elasticache_subnet_group.subnet-group.name
#  security_group_ids  = [aws_security_group.mysql.id]
#}
#
#resource "aws_elasticache_parameter_group" "default" {
#  name   = "roboshop-redis-${var.ENV}"
#  family = "redis6.x"
#}
#
#resource "aws_elasticache_subnet_group" "subnet-group" {
#  name       = "roboshop-${var.ENV}"
#  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS
#}

