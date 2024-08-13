variable "name" {
  description = "Name of the State Machine"
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role for the State Machine"
  type        = string
}

variable "definition_file" {
  description = "Path to the JSON file containing the State Machine definition"
  type        = string
}

variable "definition_vars" {
  description = "Map of variables to replace in the State Machine definition"
  type        = map(string)
  default     = {}
}