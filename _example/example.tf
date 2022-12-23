provider "google" {
  project     = var.gcp_project_id
  credentials = var.gcp_credentials
  region      = var.gcp_region
  zone        = var.gcp_zone
}
#provider "kubernetes" {
#  host                   = data.template_file.gke_host_endpoint.rendered
#  token                  = data.template_file.access_token.rendered
#  cluster_ca_certificate = data.template_file.cluster_ca_certificate.rendered
#}

module "vpc" {
  source = "git::git@github.com:cloudlovers/terraform-gcp-vpc.git"

  name        = "vpc"
  environment = "network"
  label_order = var.label_order
 # project                      = var.gcp_project_id

  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  mtu                             = 1460
  delete_default_routes_on_create = false
}

module "subnet" {
  source = "git::git@github.com:cloudlovers/terraform-google-subnet.git"

  name        = "subnet"
  environment = "network"
  label_order = var.label_order

  private_ip_google_access = true
  network                  = module.vpc.vpc_id
}



module "firewall-ssh" {
  source        = "git::git@github.com:cloudlovers/terraform-google-firewall.git"

  name        = "ssh"
  environment = "security"
  label_order = var.label_order

  network       = module.vpc.vpc_id
  protocol      = "tcp"
  ports         = ["22"]
  source_ranges = ["0.0.0.0/0"]
}

data "google_client_config" "client" {}
data "google_client_openid_userinfo" "terraform_user" {}

module "cloud_router" {
  source = ""git::git@github.com:cloudlovers/terraform-google-cloud-router.git"

  name    = "router"
  project = "manifest-device-369014"
  network = "default"

  bgp = {
    asn               = 65000
    advertised_groups = ["ALL_SUBNETS"]
  }
}

module "gke_cluster" {
  source = "../"

  name        = "gke"
  environment = "cluster"
  label_order = ["name", "environment"]

  project  = var.gcp_project_id
  location = var.location


  network    = module.vpc.vpc_id
  subnetwork = module.subnet.id
  //  cluster_secondary_range_name = ""
  //  services_secondary_range_name = ""

  disable_public_endpoint = "false"

  resource_labels = {
    environment = "testing"
  }
}
