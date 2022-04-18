# S3 Bucket: Model
resource "aws_s3_bucket" "model" {
  bucket        = var.s3_bucket_name_model
  count         = var.s3_create ? 1 : 0
  tags          = var.s3_tags
  force_destroy = var.s3_force_destroy
  #versioning    = [
  #  {
  #    enabled = var.s3_versioning_enabled
  #    mfa_delete = var.s3_versioning_mfa_delete
  #  }
  #]
}

# S3 Bucket: Data for Prediction
resource "aws_s3_bucket" "data_for_prediction" {
  bucket        = var.s3_bucket_name_data_for_prediction
  count         = var.s3_create ? 1 : 0
  tags          = var.s3_tags
  force_destroy = var.s3_force_destroy
  #versioning    = [
  #  {
  #    enabled = var.s3_versioning_enabled
  #    mfa_delete = var.s3_versioning_mfa_delete
  #  }
  #]
}

# S3 Bucket: Inference
resource "aws_s3_bucket" "inference" {
  bucket        = var.s3_bucket_name_inference
  count         = var.s3_create ? 1 : 0
  tags          = var.s3_tags
  force_destroy = var.s3_force_destroy
  #versioning    = [
  #  {
  #    enabled = var.s3_versioning_enabled
  #    mfa_delete = var.s3_versioning_mfa_delete
  #  }
  #]
}

# S3 Bucket: Training
resource "aws_s3_bucket" "training" {
  bucket        = var.s3_bucket_name_training
  count         = var.s3_create ? 1 : 0
  tags          = var.s3_tags
  force_destroy = var.s3_force_destroy
  #versioning    = [
  #  {
  #    enabled = var.s3_versioning_enabled
  #    mfa_delete = var.s3_versioning_mfa_delete
  #  }
  #]
}