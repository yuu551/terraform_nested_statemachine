# ---------------------------------------------
# Stef Functions(Module)
# ---------------------------------------------
resource "aws_sfn_state_machine" "this" {
  name     = var.name
  role_arn = var.role_arn

  # 引数で定義ファイル名と置換するパラメータを受け取る
  definition = templatefile(var.definition_file, var.definition_vars)
}