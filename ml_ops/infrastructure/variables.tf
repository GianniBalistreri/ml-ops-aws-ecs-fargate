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
  default     = "ml" #"ml-ops"
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
  default     = "ml-task-definition" #"ml-ops-task-definition"
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
  default     = "ml-task" #"ml-ops-task"
}

#variable "ecs_task_execution_role_name" {
#  description = "Name of the elastic container service execution role"
#  type        = string
#  default     = "ml-ops"
#}

variable "ecs_container_definitions_name" {
  description = "Name of the elastic container service container definitions"
  type        = string
  default     = "ml-container" #"ml-ops-container"
}

variable "ecs_container_definitions_awslogs_stream_prefix" {
  description = "Name of the elastic container service container definitions aws logs stream prefix"
  type        = string
  default     = "ml" #"ml-ops"
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
  description = "Name of the terraform backend folder"
  type        = string
  default     = "gfb-ml-ops-tf-infrastructure"
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
  default     = true
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




variable "aws_alb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "ml-load-balancer" #"ml-ops-load-balancer"
}

variable "aws_alb_target_group_name" {
  description = "Name of the load balancer target group"
  type        = string
  default     = "ml-target-group" #"ml-ops-target-group"
}

variable "aws_ecs_task_definition_name" {
  description = "Name of the elastic container service task definition"
  type        = string
  default     = "ml-task" #"ml-ops-task"
}

variable "aws_ecs_task_definition_container_definition_name" {
  description = "Name of the elastic container service task definition container definition"
  type        = string
  default     = "ml" #"ml-ops"
}

variable "aws_ecs_service_name" {
  description = "Name of the elastic container service"
  type        = string
  default     = "ml" #"ml-service"#"ml-ops-service"
}

variable "aws_vpc_cidr" {
  description = "The CIDR of the main vpc"
  default     = "172.17.0.0/16"
}

variable "remote_cidr_blocks" {
  type        = list(any)
  default     = ["10.0.0.0/32"]
  description = "By default cidr_blocks are locked down. (Update to 0.0.0.0/0 if full public access is needed)"
}

variable "vpc_id" {
  description = "ECS VPC ID"
  type        = string
  default     = "vpc"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  type        = string
  default     = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  type        = string
  default     = "2"
}

variable "training_container_image" {
  description = "Docker image to run in the ECS cluster to train ml model"
  type        = string
  default     = "training:latest"
}

variable "inference_container_image" {
  description = "Docker image to run in the ECS cluster to generate inferences from pre-trained ml model"
  type        = string
  default     = "inference:latest"
}

variable "ml_ops_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  type        = number
  default     = 80
}

variable "container_count" {
  description = "Number of docker containers to run"
  type        = string
  default     = "3"
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  type        = number
  default     = 256
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  type        = number
  default     = 512
}




variable "name" {
  description = "Name given resources"
  type        = string
  default     = "aws-ia"
}

variable "service_name" {
  type        = string
  default     = "nginx"
  description = "A name for the service"
}

variable "image_url" {
  type        = string
  default     = "nginx"
  description = "the url of a docker image that contains the application process that will handle the traffic for this service"
}

variable "container_port" {
  type        = number
  default     = 80
  description = "What port number the application inside the docker container is binding to"
}

variable "container_cpu" {
  type        = number
  default     = 50
  description = "How much CPU to give the container. 1024 is 1 CPU"
}

variable "container_memory" {
  type        = number
  default     = 512
  description = "How much memory in megabytes to give the container"
}

variable "lb_public_access" {
  type        = bool
  default     = true
  description = "Make LB accessible publicly"
}

variable "lb_path" {
  type        = string
  default     = "*"
  description = "A path on the public load balancer that this service should be connected to. Use * to send all load balancer traffic to this service."
}

variable "routing_priority" {
  type        = number
  default     = 1
  description = "The priority for the routing rule added to the load balancer. This only applies if your have multiple services which have been assigned to different paths on the load balancer."
}

variable "desired_count" {
  type        = number
  default     = 2
  description = "How many copies of the service task to run"
}

variable "name_prefix" {
  description = "Name Prefix"
  type        = string
  default     = "fw"
}

variable "network_tag" {
  description = "Tags used to filter ecs subnets "
  type        = string
  default     = "ecs-subnets"
}
