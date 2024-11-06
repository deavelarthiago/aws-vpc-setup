##################################################################################################

**aws-vpc-setup**

##################################################################################################

Purpose:
This repository provides Terraform configurations to set up a VPC within AWS, including public and private subnets spanning multiple availability zones.

Prerequisites:
- Terraform v0.12.x or higher;
- AWS account with access configured in your development environment and with the necessary permissions to create all resources.

Created Resources:
**VPC** Sets up a VPC within the specified CIDR range.
**Public Subnets** For resources that must be directly accessible from the internet.
**Private Subnets** For resources that shouldn't be directly accessed from the outside.
**Route Tables** Separate route tables for public and private subnets.
**Internet Gateway** To allow public subnets to connect to the internet.

## Notes ##
- The variables `region` and `environment` must be defined before the implementation of the resources begins.
- The value provided for the environment will be used to name the resources.
    
An example of how this will work:

variable "environment" {
  description = "Specifies the deployment environment (e.g., dev, staging, production)."
  type        = string
**default     = "dev"**
}
 
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    environment = var.environment,
  **Name        = "vpc-for-${var.environment}-environment"**
  }
}

As the selected environment was **dev** the VPC name will be: `vpc-for-dev-environment`

Before using the provided code, consider following the best practice of managing the Terraform backend. This ensures that the infrastructure is managed consistently and securely, especially in collaborative environments where multiple people or teams may be configuring resources simultaneously. With a centralized and versioned tfstate, conflicts and errors from outdated states are avoided, and auditing and restoring previous versions become possible, increasing the reliability and transparency of the entire operation.

To implement this practice efficiently, the detailed procedure was in the following project, which provides a backend configuration using S3 as an example:

https://github.com/deavelarthiago/terraform-s3-backend-management

This process provides a solid foundation to ensure shared and protected state, preparing the environment for the safe and organized execution of other projects.