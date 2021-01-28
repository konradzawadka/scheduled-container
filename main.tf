


resource "aws_ecs_task_definition" "task" {
  family                = var.name
  container_definitions = jsonencode([{
        name = var.name
        image = var.image_url
        repositoryCredentials = var.repositoryCredentials

        essential = true
        cpu = var.cpu
        memory = var.ram
        entrypoint = ["sh","-c"]
        environment = var.environment
        command = [ var.command ]
        logConfiguration = {
            logDriver = "awslogs"
            options = {
                awslogs-create-group = "true"
                awslogs-group = "awslogs-crawler"
                awslogs-region = "eu-central-1"
                awslogs-stream-prefix = "awslogs-example"
            }
        }
  }])
  requires_compatibilities = ["FARGATE"]
  cpu = var.cpu
  memory = var.ram
  network_mode = "awsvpc"
  execution_role_arn = var.role_arn
  task_role_arn = var.role_arn
}



resource "aws_cloudwatch_event_rule" "console" {
  name        = format("%s_event_rule", var.name)
  schedule_expression = var.cron
}

resource "aws_cloudwatch_event_target" "console" {
  depends_on  = [
    aws_cloudwatch_event_rule.console
  ]
  
  target_id = format("%s", var.name)
  arn       = var.cluster_arn
  rule      = aws_cloudwatch_event_rule.console.name
  role_arn  = var.role_arn


  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.task.arn
    launch_type = "FARGATE"
    network_configuration {
      assign_public_ip = true
      subnets = [var.subnet_id]
    }
  }

}