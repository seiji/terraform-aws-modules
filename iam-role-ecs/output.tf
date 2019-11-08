output ecs_task_execution {
  value = aws_iam_role.ecs_task_execution
}

output ecs_service {
  value = aws_iam_role.ecs_service.arn
}
