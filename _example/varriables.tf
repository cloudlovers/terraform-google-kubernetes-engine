variable "gcp_project_id" {
  type        = string
  default     = "manifest-device-369014"
  description = "Google Cloud project ID"
}
variable "gcp_credentials" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Google Cloud service account credentials"
}
variable "gcp_region" {
  type        = string
  default     = "europe-west3"
  description = "Google Cloud region"
}
variable "gcp_zone" {
  type        = string
  default     = "Europe-west3-c"
  description = "Google Cloud zone"
}
variable "location" {
  description = "The location (region or zone) of the GKE cluster."
  default     = "europe-west3"
  type        = string
}

variable "label_order" {
  description = ""
  default     = ["name", "environment"]
  type        = list(string)
}

variable "kubectl_config_path" {
  description = "Path to the kubectl config file. Defaults to $HOME/.kube/config"
  type        = string
  default     = ""
}

variable "name" {
  type = string
  default = ""
}