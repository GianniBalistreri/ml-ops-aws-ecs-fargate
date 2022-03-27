#########
# Misc: #
#########

variable "aws_region" {
  description = "AWS region code"
  type        = string
  default     = "eu-central-1"
}

variable "env" {
  description = "Staging environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

############
# AWS ECR: #
############

variable "ecr_name" {
  description = "Name of the elastic container registry"
  type        = string
  default     = "ml-ops"
}

variable "ecr_image_tag_mutability" {
  description = "Mutability image tag"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_scan_on_push" {
  description = "Scan container image on push"
  type        = bool
  default     = true
}

############
# AWS ECS: #
############

variable "ecs_cluster_name" {
  description = "Name of the elastic cluster service cluster"
  type        = string
  default     = "ml-ops"
}

variable "ecs_vpc_cidr_block" {
  description = "Cidr block vpc port"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ecs_enable_dns_hostnames" {
  description = "Whether to enable dns hostnames or not"
  type        = bool
  default     = true
}

variable "ecs_task_definition_name" {
  description = "Name of the elastic container service task definition"
  type        = string
  default     = "ml-ops-task-definition"
}

variable "ecs_task_definition_network_mode" {
  description = "Mode of the elastic container service task definition"
  type        = string
  default     = "awsvpc"
}

variable "ecs_task_definition_cpu" {
  description = "Number of CPU's of the elastic container service task definition"
  type        = string
  default     = "4"
}

variable "ecs_task_definition_memory" {
  description = "Amount of memory of the elastic container service task definition"
  type        = string
  default     = "1024"
}

variable "ecs_task_role_name" {
  description = "Name of the elastic container service role"
  type        = string
  default     = "ml-ops-task"
}

variable "ecs_task_execution_role_name" {
  description = "Name of the elastic container service execution role"
  type        = string
  default     = "ml-ops"
}

variable "ecs_container_definitions_name" {
  description = "Name of the elastic container service container definitions"
  type        = string
  default     = "ml-ops-container"
}

variable "ecs_container_definitions_awslogs_stream_prefix" {
  description = "Name of the elastic container service container definitions aws logs stream prefix"
  type        = string
  default     = "ml-ops"
}

##################
# AWS S3 Bucket: #
##################

variable "s3_create" {
  description = "Whether to create this resource or not"
  type        = bool
  default     = true
}

variable "s3_bucket_name_infrastructure" {
  description = "Name of the infrastructure bucket"
  type        = string
  default     = "gfb-ml-ops-infrastructure"
}

variable "s3_bucket_name_infrastructure_tf_state" {
  description = "Name of the terraform backend folder"
  type        = string
  default     = "terraform"
}

variable "s3_bucket_name_infrastructure_ecs_container_definitions_env" {
  description = "Name of the elastic container service container definitions environment folder"
  type        = string
  default     = "ecs"
}

variable "s3_bucket_name_data_for_prediction" {
  description = "Name of the bucket for input data used to generate predicitons from"
  type        = string
  default     = "gfb-ml-ops-data-for-prediction"
}

variable "s3_bucket_name_inference" {
  description = "Name of the bucket for output data containing generated predicitons"
  type        = string
  default     = "gfb-ml-ops-inference"
}

variable "s3_bucket_name_training" {
  description = "Name of the bucket for intput data used for training"
  type        = string
  default     = "gfb-ml-ops-training"
}

variable "s3_bucket_name_model" {
  description = "Name of the bucket for output model artefact"
  type        = string
  default     = "gfb-ml-ops-model"
}

variable "s3_key" {
  description = "Name of the object once it is in the bucket"
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
  type        = string
  default     = "d-day"
}

variable "git_repo_url" {
  description = "URL of the git repository"
  type        = string
  default     = "https://github.com/GianniBalistreri/d-day.git"
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
  type        = string
  default     = "ml-ops-sagemaker-lifecycle-config"
}

variable "sagemaker_notebook_iam_role_name" {
  description = "Name of the sagemaker notebook iam role"
  type        = string
  default     = "sagemaker-notebook-role"
}

variable "sagemaker_notebook_iam_policy_name" {
  description = "Name of the sagemaker notebook iam policy"
  type        = string
  default     = "sagemaker-full-access-attachment"
}
