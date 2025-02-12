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

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_public_subnet_count" {
  type        = number
  description = "subnets"
  default     = 2
  validation {
    condition     = var.vpc_public_subnet_count < 6 && var.vpc_public_subnet_count > 1
    error_message = "min value is 2 and max value is 5"
  }
}

variable "instance_type" {
  type        = string
  description = "Type of instances to create"
  default     = "t3.micro"
}


variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  default     = 2
}

variable "prefix" {
  type        = string
  description = "Prefix"
  default     = "globo-web-app"
}


