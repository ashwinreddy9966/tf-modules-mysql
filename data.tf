data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "robot-terraform-remote-state"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}
