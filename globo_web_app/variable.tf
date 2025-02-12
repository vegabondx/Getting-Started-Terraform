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

variable "vpc_public_subnet_count" {
  type = number
  description = "subnets"
  default = 2
  validation {
    condition = var.vpc_public_subnet_count>5 && var.vpc_public_subnet_count > 1
    error_message = "min value is 2 and max value is 5"
  }
}
