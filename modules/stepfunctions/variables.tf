variable "name" {
  description = "Name of the Step Function"
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role for the Step Function"
  type        = string
}

variable "definition_file" {
  description = "Path to the JSON file containing the Step Function definition"
  type        = string
}

variable "definition_vars" {
  description = "Map of variables to replace in the Step Function definition"
  type        = map(string)
  default     = {}
}