output "deployment_info" {
  description = "Displays the environment and region where the resources are being deployed."
  value = "These resources are being deployed in the **${var.environment}** environment in the **${var.region}** region."
}
