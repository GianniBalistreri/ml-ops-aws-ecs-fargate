resource "aws_ecr_repository" "training" {
  name                 = var.ecr_name_training
  image_tag_mutability = var.ecr_image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }
  tags = {
    Env = var.env
  }
}

resource "aws_ecr_repository" "inference" {
  name                 = var.ecr_name_inference
  image_tag_mutability = var.ecr_image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }
  tags = {
    Env = var.env
  }
}

resource "aws_ecr_repository" "inference_api" {
  name                 = var.ecr_name_inference_api
  image_tag_mutability = var.ecr_image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }
  tags = {
    Env = var.env
  }
}
