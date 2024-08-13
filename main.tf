terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.61.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
}

# ---------------------------------------------
# ステートマシンの実行ロール
# ---------------------------------------------
resource "aws_iam_role" "state_machine_role" {
  name = "step_function_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

# ---------------------------------------------
# ステートマシンの実行用ポリシー
# ---------------------------------------------
resource "aws_iam_policy" "step_functions_policy" {
  name        = "step_functions_execution_policy"
  path        = "/"
  description = "IAM policy for Step Functions execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "states:StartExecution",
          "states:DescribeExecution",
          "states:StopExecution",
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule",
          "events:CreateRule"
        ]
        Resource = "*"
      }
    ]
  })
}

# ---------------------------------------------
# ステートマシンのロールとポリシーの紐付け
# ---------------------------------------------
resource "aws_iam_role_policy_attachment" "step_functions_policy_attachment" {
  role       = aws_iam_role.state_machine_role.name
  policy_arn = aws_iam_policy.step_functions_policy.arn
}

# ---------------------------------------------
# メインのStatemachine
# ---------------------------------------------
module "main_sfn" {
  source          = "./modules/stepfunctions"
  name            = "main_sfn"
  role_arn        = aws_iam_role.state_machine_role.arn
  definition_file = "./asls/main_sfn.asl.json"
  definition_vars = {
    nested_state_machine_arn = module.nested_sfn.arn
  }
}

# ---------------------------------------------
# サブのStatemachine
# ---------------------------------------------
module "nested_sfn" {
  source          = "./modules/stepfunctions"
  name            = "nested_sfn"
  role_arn        = aws_iam_role.state_machine_role.arn
  definition_file = "./asls/nested_sfn.asl.json"
  definition_vars = {}
}