variable "gcp_project_id" {
  description = "The GCP Project ID"
  type        = string
  default     = "flash-physics-368407"
}

variable "gcp_credentials" {
  description = "GCP Access Key stored in Terraform Cloud"
  type        = string
  sensitive   = true
}