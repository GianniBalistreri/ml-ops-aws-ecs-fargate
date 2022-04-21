resource "aws_alb" "main" {
  name            = var.aws_alb_name
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "ml" {
  name        = var.aws_alb_target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.ml_ops_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ml.id
    type             = "forward"
  }
}

resource "aws_ecs_cluster" "ecs_fargate" {
  name       = var.ecs_cluster_name
  depends_on = [aws_ecr_repository.ecr]
}

resource "aws_ecs_task_definition" "ml" {
  family                   = var.ecs_task_definition_name
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = jsonencode([
    {
      "name" : var.aws_ecs_task_definition_container_definition_name,
      "image" : var.training_container_image,
      "cpu" : var.fargate_cpu,
      "memory" : var.fargate_memory,
      "networkMode" : "awsvpc",
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/${var.aws_ecs_task_definition_container_definition_name}",
          "awslogs-region" : var.aws_region,
          "awslogs-stream-prefix" : "ecs"
        }
      },
      "portMappings" : [
        {
          "containerPort" : var.ml_ops_port,
          "hostPort" : var.ml_ops_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = var.aws_ecs_service_name
  cluster         = aws_ecs_cluster.ecs_fargate.id
  task_definition = aws_ecs_task_definition.ml.arn
  desired_count   = var.container_count
  launch_type     = "FARGATE"
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.ml.id
    container_name   = var.aws_ecs_service_name
    container_port   = var.ml_ops_port
  }
  depends_on = [
    aws_alb_listener.front_end,
    aws_iam_role_policy_attachment.ecs_task_execution_role
  ]
}

resource "aws_appautoscaling_target" "ecs_autoscaling_target" {
  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_fargate.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on = [
    aws_ecs_cluster.ecs_fargate,
    aws_ecs_service.main
  ]
}
