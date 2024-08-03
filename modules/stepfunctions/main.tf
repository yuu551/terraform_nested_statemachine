resource "aws_sfn_state_machine" "this" {
  name     = var.name
  role_arn = var.role_arn

  definition = templatefile(var.definition_file, var.definition_vars)
}