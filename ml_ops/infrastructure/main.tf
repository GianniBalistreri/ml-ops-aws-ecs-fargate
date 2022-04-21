# Terraform config:
terraform {
  backend "s3" {
    bucket = "gfb-ml-ops-tf-infrastructure"
    key    = "ecs-fargate/tf-state"
    region = "eu-central-1"
  }
}
