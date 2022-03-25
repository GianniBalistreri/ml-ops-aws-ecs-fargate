####################
# AWS S3 IAM Role: #
####################

data "aws_iam_policy_document" "s3" {
  version = "2012-10-17"
  statement {
      effect = "Allow"
      actions = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
          ]
      resources = [
          "arn:aws:s3:::${var.s3_bucket_name_tf}"
          ]
    }
    statement {
      effect = "Allow"
      actions= [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
          ]
      resources = [
          "arn:aws:s3:::${var.s3_bucket_name_model}"
          ]
    }
    statement {
      effect = "Allow"
      actions = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
          ]
      resources = [
          "arn:aws:s3:::${var.s3_bucket_name_data_for_prediction}"
          ]
    }
    statement {
      effect = "Allow"
      actions = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
          ]
      resources = [
          "arn:aws:s3:::${var.s3_bucket_name_inference}"
          ]
    }
    statement {
      effect = "Allow"
      actions = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
          ]
      resources = [
          "arn:aws:s3:::${var.s3_bucket_name_training}"
          ]
    }
}

############################
# AWS Sagemaker IAM Roles: #
############################

# Defining the SageMaker "Assume Role" policy
data "aws_iam_policy_document" "sm_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

# Defining the SageMaker notebook IAM role
resource "aws_iam_role" "notebook_iam_role" {
  name = var.sagemaker_notebook_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.sm_assume_role_policy.json
}

# Attaching the AWS default policy, "AmazonSageMakerFullAccess"
resource "aws_iam_policy_attachment" "sm_full_access_attach" {
  name = var.sagemaker_notebook_iam_policy_name
  roles = [aws_iam_role.notebook_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}