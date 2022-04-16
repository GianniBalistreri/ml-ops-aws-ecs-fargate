# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/ecs/${var.aws_ecs_service_name}"
  retention_in_days = 30
  tags = {
    Name = "${var.aws_ecs_service_name}-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
  name           = "${var.aws_ecs_service_name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group.name
}