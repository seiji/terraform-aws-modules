# output ecs_task_execution {
#   value = module.iam_role_ecs_task_execution.arn
# }
#
# output ecs_service {
#   value = aws_iam_role.ecs_service.arn
# }
#
output "instance_profile_id" {
  value = aws_iam_instance_profile.this.id
}
