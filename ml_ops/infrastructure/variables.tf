# Staging Environment:
variable "env" {
  description = "Environment (Dev, Stage, Prod)"
  default     = "dev"
  type        = string
}

##################
# AWS S3 Bucket: #
##################

variable "s3_create" {
  description = "Whether to create this resource or not"
  type        = bool
  default     = true
}

variable "s3_bucket_name_tf" {
  description = "The name of the terraform backend bucket"
  type        = string
  default     = "gfb-ml-ops-terraform"
}

variable "s3_bucket_name_data_for_prediction" {
  description = "The name of the bucket for input data used to generate predicitons from"
  type        = string
  default     = "gfb-ml-ops-data-for-prediction"
}

variable "s3_bucket_name_inference" {
  description = "The name of the bucket for output data containing generated predicitons"
  type        = string
  default     = "gfb-ml-ops-inference"
}

variable "s3_bucket_name_training" {
  description = "The name of the bucket for intput data used for training"
  type        = string
  default     = "gfb-ml-ops-training"
}

variable "s3_bucket_name_model" {
  description = "The name of the bucket for output model artefact"
  type        = string
  default     = "gfb-ml-ops-model"
}

variable "s3_key" {
  description = "The name of the object once it is in the bucket"
  type        = string
  default     = ""
}

variable "s3_acl" {
  description = "The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, and bucket-owner-full-control"
  type        = string
  default     = "private"
}

variable "s3_tags" {
  description = "A map of tags to assign to the object"
  type        = map(string)
  default = {
    Environment = "dev"
  }
}

variable "s3_force_destroy" {
  description = "Allow the object to be deleted by removing any legal hold on any object version. Default is false. This value should be set to true only if the bucket has S3 object lock enabled"
  type        = bool
  default     = false
}

variable "s3_versioning_enabled" {
  description = "Enable versioning or not"
  type        = bool
  default     = true
}

variable "s3_versioning_mfa_delete" {
  description = "Delete multi factor authentification or not"
  type        = bool
  default     = false
}

##################
# AWS Sagemaker: #
##################

variable "git_repo_name" {
  description = "Name of the git repository"
  type = string
  default = "d-day"
}

variable "git_repo_url" {
  description = "URL of the git repository"
  type = string
  default = "https://github.com/GianniBalistreri/d-day.git"
}

variable "sagemaker_notebook_instance_name" {
  description = "Name of the sagemaker notebook"
  type        = string
  default     = "exploration"
}

variable "sagemaker_notebook_instance_type" {
  description = "Name of the underlying ec2 instance"
  type        = string
  default     = "ml.t2.medium"
}

variable "sagemaker_notebook_lifecycle_config" {
  description = "Name of the sagemaker notebook lifecycle configuration"
  type = string
  default = "ml-ops-sagemaker-lifecycle-config"
}

variable "sagemaker_notebook_iam_role_name" {
  description = "Name of the sagemaker notebook iam role"
  type = string
  default = "sagemaker-notebook-role"
}

variable "sagemaker_notebook_iam_policy_name" {
  description = "Name of the sagemaker notebook iam policy"
  type = string
  default = "sagemaker-full-access-attachment"
}