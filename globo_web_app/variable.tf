variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "company" {
  type        = string
  default     = "globomantics"
  description = "Name of the company"
}

variable "project" {
  type        = string
  description = "project"
}
variable "billing_code" {
  type        = string
  description = "billings code"
}

