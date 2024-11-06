variable "region" {
  description = "AWS region where resources will be deployed. Set the default region to deploy resources if not specified."
  type        = string
  default     = "<specify default AWS region here>"
}

variable "environment" {
  description = "Specifies the deployment environment (e.g., dev, staging, production)."
  type        = string
  default     = "<especify default environment where resources will be deployed>"
}

variable "cidr_block" {
  description = "CIDR for the VPC"
  default     = "10.1.0.0/16"
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "private_subnets_cidr" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
}
