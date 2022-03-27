resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
  depends_on = [
    aws_ecr_repository.ecr
  ]
}

resource "aws_ecs_task_definition" "definition" {
  family                   = var.ecs_task_definition_name
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = var.ecs_task_definition_network_mode
  cpu                      = var.ecs_task_definition_cpu
  memory                   = var.ecs_task_definition_memory
  requires_compatibilities = ["FARGATE"]
  container_definitions = <<DEFINITION
[
  {
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecs_task_execution_role_name}:latest",
    "name": "${var.ecs_container_definitions_name}",
    "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-region" : "${var.aws_region}",
                    "awslogs-group" : "stream-to-log-fluentd",
                    "awslogs-stream-prefix" : "${var.ecs_container_definitions_awslogs_stream_prefix}"
                }
            },
    "secrets": [{
        "name": "secret_variable_name",
        "valueFrom": "arn:aws:ssm:region:acount:parameter/parameter_name"
    }],           
    "environment": [
            {
                "name": "bucketName",
                "value": "${var.s3_bucket_name_infrastructure}"
            },
            {
                "name": "folder",
                "value": "${var.s3_bucket_name_infrastructure_ecs_container_definitions_env}"
            }
        ]
    }
]
DEFINITION
depends_on = [
  aws_ecs_cluster.cluster,
  aws_vpc.ecs_vpc,
  aws_iam_role.ecs_task_role,
  aws_iam_role.ecs_task_execution_role,
  aws_iam_role_policy_attachment.task_s3,
  aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment
]
}