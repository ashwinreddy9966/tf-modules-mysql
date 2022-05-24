data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "robot-terraform-remote-state"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_secretsmanager_secret" "secret" {
  name = "${var.ENV}/roboshop/secrets"
}

data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}
