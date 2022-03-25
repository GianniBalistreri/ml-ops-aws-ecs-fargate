# Defining the Git repo to instantiate on the SageMaker notebook instance
resource "aws_sagemaker_code_repository" "git_repo" {
  code_repository_name = var.git_repo_name
  git_config {
    repository_url = var.git_repo_url
  }
}

# Defining the SageMaker notebook lifecycle configuration
resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "notebook_config" {
  name = var.sagemaker_notebook_lifecycle_config
  on_create = filebase64("../scripts/aws_sagemaker_notebook_setup_idle_auto_stop.sh")
  on_start = filebase64("../scripts/aws_sagemaker_notebook_setup_custom_kernel.sh")
}

# Creating the SageMaker notebook instance
resource "aws_sagemaker_notebook_instance" "notebook_instance" {
  name = var.sagemaker_notebook_instance_name
  role_arn = aws_iam_role.notebook_iam_role.arn
  instance_type = var.sagemaker_notebook_instance_type
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.notebook_config.name
  default_code_repository = aws_sagemaker_code_repository.git_repo.code_repository_name
}