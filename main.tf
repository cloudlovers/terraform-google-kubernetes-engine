module "labels" {
  source = "git::git@github.com:cloudlovers/terraform-google-labels.git"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}

locals {
  workload_identity_config = !var.enable_workload_identity ? [] : var.identity_namespace == null ? [{
    identity_namespace = "${var.project}.svc.id.goog" }] : [{ identity_namespace = var.identity_namespace
  }]
}

resource "google_container_cluster" "cluster" {
  provider = google-beta

  name        = var.name
  description = var.description

  project    = var.project
  location   = var.location
  network    = var.network
  subnetwork = var.subnetwork

  logging_service          = var.logging_service
  monitoring_service       = var.monitoring_service
  min_master_version       = local.kubernetes_version
  enable_legacy_abac       = var.enable_legacy_abac
  remove_default_node_pool = true
  initial_node_count       = 1


  dynamic "node_config" {
    for_each = [
      for x in [var.alternative_default_service_account] : x if var.alternative_default_service_account != null
    ]

    content {
      service_account = node_config.value
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_endpoint = var.disable_public_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  addons_config {
    http_load_balancing {
      disabled = !var.http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = !var.horizontal_pod_autoscaling
    }

    network_policy_config {
      disabled = !var.enable_network_policy
    }
  }

  network_policy {
    enabled = var.enable_network_policy

    provider = var.enable_network_policy ? "CALICO" : "PROVIDER_UNSPECIFIED"
  }

  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = lookup(master_authorized_networks_config.value, "cidr_blocks", [])
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = lookup(cidr_blocks.value, "display_name", null)
        }
      }
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  lifecycle {
    ignore_changes = [
      node_config,
    ]
  }

  dynamic "authenticator_groups_config" {
    for_each = [
      for x in [var.gsuite_domain_name] : x if var.gsuite_domain_name != null
    ]

    content {
      security_group = "gke-security-groups@${authenticator_groups_config.value}"
    }
  }

  dynamic "database_encryption" {
    for_each = [
      for x in [var.secrets_encryption_kms_key] : x if var.secrets_encryption_kms_key != null
    ]

    content {
      state    = "ENCRYPTED"
      key_name = database_encryption.value
    }
  }
  //
  //  dynamic "workload_identity_config" {
  //    for_each = var.workload_identity_config
  //
  //   content {
  //    identity_namespace = "cloudlovers.svc.id.goog"
  //   }
  //  }

  resource_labels = var.resource_labels
}

# ---------------------------------------------------------------------------------------------------------------------
# Prepare locals to keep the code cleaner
# ---------------------------------------------------------------------------------------------------------------------

locals {
  latest_version     = data.google_container_engine_versions.location.latest_master_version
  kubernetes_version = var.kubernetes_version != "latest" ? var.kubernetes_version : local.latest_version
  network_project    = var.network_project != "" ? var.network_project : var.project
}

# ---------------------------------------------------------------------------------------------------------------------
# Pull in data
# ---------------------------------------------------------------------------------------------------------------------

data "google_container_engine_versions" "location" {
  location = var.location
  project  = var.project
}


//resource "google_container_node_pool" "node_pool" {
//  provider = google-beta
//
//  name               = var.node_name
//  project            = var.project
//  location           = var.location
//  cluster            = var.cluster
//  initial_node_count = var.initial_node_count
//
//  autoscaling {
//    min_node_count  = var.min_node_count
//    max_node_count  = var.max_node_count
//    location_policy = var.location_policy
//  }
//
//  management {
//    auto_repair  = var.auto_repair
//    auto_upgrade = var.auto_upgrade
//  }
//
//  node_config {
//    image_type   = var.image_type
//    machine_type = var.machine_type
//
//    labels = {
//      all-pools-example = "true"
//    }
//
//
//    disk_size_gb = var.disk_size_gb
//    disk_type    = var.disk_type
//    preemptible  = var.preemptible
//
//
//  }
//
//  lifecycle {
//    ignore_changes        = [initial_node_count]
//    create_before_destroy = false
//
//  }
//
//  timeouts {
//    create = var.cluster_create_timeouts
//    update = var.cluster_update_timeouts
//    delete = var.cluster_delete_timeouts
//  }
//}
//
//resource "null_resource" "configure_kubectl" {
//  provisioner "local-exec" {
//    command = "gcloud beta container clusters get-credentials ${var.cluster_name} --region ${var.gcp_region} --project ${var.gcp_project_id}"
//
//    environment = {
//      KUBECONFIG = var.kubectl_config_path != "" ? var.kubectl_config_path : ""
//    }
//  }
//
////  depends_on = [google_container_node_pool.node_pool]
//}
//
//data "google_client_config" "client" {}
//data "google_client_openid_userinfo" "terraform_user" {}
//
//resource "kubernetes_cluster_role_binding" "user" {
//  metadata {
//    name = "admin-user"
//  }
//
//  role_ref {
//    kind      = "ClusterRole"
//    name      = "cluster-admin"
//    api_group = "rbac.authorization.k8s.io"
//  }
//
//  subject {
//    kind      = "User"
//    name      = data.google_client_openid_userinfo.terraform_user.email
//    api_group = "rbac.authorization.k8s.io"
//  }
//
//  subject {
//    kind      = "Group"
//    name      = "system:masters"
//    api_group = "rbac.authorization.k8s.io"
//  }
//}


