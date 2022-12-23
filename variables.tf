variable "environment" {
  type    = string
  default = ""
}

variable "label_order" {
  type    = list(any)
  default = []
}

variable "project" {
  description = "The project ID to host the cluster in"
  default = "my_project_id"
  type        = string
}

variable "location" {
  description = "The location (region or zone) to host the cluster in"
  type        = string
}

variable "name" {
  description = "The name of the cluster"
  default = ""
  type        = string
}

variable "network" {
  default = ""
  type = string
}

variable "subnetwork" {
  type    = string
  default = ""
}

variable "cluster_secondary_range_name" {
  type    = string
  default = ""
}

variable "description" {
  type    = string
  default = ""
}

variable "kubernetes_version" {
  type    = string
  default = "latest"
}

variable "logging_service" {
  type    = string
  default = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  type    = string
  default = "monitoring.googleapis.com/kubernetes"
}

variable "horizontal_pod_autoscaling" {
  type    = bool
  default = true
}

variable "http_load_balancing" {
  type    = bool
  default = true
}

variable "enable_private_nodes" {
  type    = bool
  default = false
}

variable "disable_public_endpoint" {
  type    = bool
  default = false
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = ""
}

variable "network_project" {
  type    = string
  default = ""
}

variable "master_authorized_networks_config" {
  description = <<EOF
  The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)
  ### example format ###
  master_authorized_networks_config = [{
    cidr_blocks = [{
      cidr_block   = "10.0.0.0/8"
      display_name = "example_network"
    }],
  }]
EOF
  type        = list(any)
  default     = []
}

variable "maintenance_start_time" {
  type    = string
  default = "05:00"
}

variable "stub_domains" {
  type    = map(string)
  default = {}
}

variable "non_masquerade_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "ip_masq_resync_interval" {
  type    = string
  default = "60s"
}

variable "ip_masq_link_local" {
  type    = bool
  default = false
}

variable "alternative_default_service_account" {
  type    = string
  default = null
}

variable "resource_labels" {
  type    = map(any)
  default = {}
}

variable "enable_legacy_abac" {
  type    = bool
  default = false
}

variable "enable_network_policy" {
  type    = bool
  default = true
}

variable "basic_auth_username" {
  type    = string
  default = ""
}

variable "basic_auth_password" {
  type    = string
  default = ""
}

variable "enable_client_certificate_authentication" {
  type    = bool
  default = false
}

variable "gsuite_domain_name" {
  type    = string
  default = null
}

variable "secrets_encryption_kms_key" {
  type    = string
  default = null
}

variable "enable_vertical_pod_autoscaling" {
  type    = string
  default = false
}

variable "services_secondary_range_name" {
  type    = string
  default = null
}

variable "enable_workload_identity" {
  default = false
  type    = bool
}

variable "service_account_roles" {
  type    = list(string)
  default = []
}

variable "workload_identity_config" {
  type    = list(any)
  default = []

}

variable "authenticator_groups_config" {
  type    = string
  default = ""
}

variable "identity_namespace" {
  type    = string
  default = ""

}

variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "Google Cloud project ID"
}

variable "gcp_region" {
  type        = string
  default     = ""
  description = "Google Cloud region"
}


variable "cluster_name" {
  type    = string
  default = ""
}

variable "node_name" {
  type    = string
  default = ""
}


variable "cluster" {
  type    = string
  default = ""
}


variable "initial_node_count" {
  type    = number
  default = 1
}
######################### Autoscaling ###########################
variable "min_node_count" {
  type    = number
  default = 2
}

variable "max_node_count" {
  type    = number
  default = 7
}

variable "location_policy" {
  type    = string
  default = "BALANCED"
}

######################### management ###########################
variable "auto_repair" {
  type    = bool
  default = true
}

variable "auto_upgrade" {
  type    = bool
  default = false
}

######################### node_config ###########################
variable "image_type" {
  type    = string
  default = ""
}

variable "machine_type" {
  type    = string
  default = ""
}

variable "disk_size_gb" {
  type    = number
  default = 50
}

variable "disk_type" {
  type    = string
  default = ""
}

variable "preemptible" {
  type    = bool
  default = false
}

######################### timeouts ###########################
variable "cluster_create_timeouts" {
  type    = string
  default = "30m"
}

variable "cluster_update_timeouts" {
  type    = string
  default = "30m"
}

variable "cluster_delete_timeouts" {
  type    = string
  default = "30m"
}


variable "node_pool" {
  type    = any
  default = {}
}

variable "kubectl_config_path" {
  description = "Path to the kubectl config file. Defaults to $HOME/.kube/config"
  type        = string
  default     = ""
}