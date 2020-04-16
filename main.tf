## Data

data "google_compute_zones" "available" {}

## ID of this infrastructure - we use this for uniquness and tracking resources
resource "random_string" "id" {
  length  = 8
  special = false
}

## locals
locals {
  infra_id      = random_string.id.result
  prow_base_url = "prow.${var.base_domain}"
  tags = {
    SYSTEM = var.system
    UUID   = random_string.id.result
  }
}

resource "google_project_service" "project" {
  for_each = var.google_apis

  project                    = var.gcloud_project
  service                    = each.value
  disable_dependent_services = false
}

## Modules
module "gke-cluster" {
  source = "github.com/ouzi-dev/gke-terraform.git?ref=v0.9.2"
  #source  = "../gke-terraform"
  region  = var.gcloud_region
  project = var.gcloud_project

  cluster_name = var.gke_name
  zones        = slice(data.google_compute_zones.available.names, 0, var.gke_num_of_zones)

  node_cidr_range    = var.gke_node_cidr_range
  pod_cidr_range     = var.gke_pod_cidr_range
  service_cidr_range = var.gke_service_cidr_range
  master_cidr_range  = var.gke_master_cidr_range
  gke_node_scopes    = var.gke_node_scopes
  auth_cidr_blocks   = var.gke_auth_cidr_blocks
  kubernetes_version = var.gke_kubernetes_version

  cluster_autoscaling            = var.cluster_autoscaling
  cluster_autoscaling_min_cpu    = var.cluster_autoscaling_min_cpu
  cluster_autoscaling_max_cpu    = var.cluster_autoscaling_max_cpu
  cluster_autoscaling_min_memory = var.cluster_autoscaling_min_memory
  cluster_autoscaling_max_memory = var.cluster_autoscaling_max_memory

  machine_type           = var.gke_machine_type
  machine_disk_size      = var.gke_machine_disk_size
  machine_is_preemptible = var.gke_machine_is_preemptible
  min_nodes              = var.gke_min_nodes
  max_nodes              = var.gke_max_nodes
  max_surge              = var.max_surge
  max_unavailable        = var.max_unavailable

  daily_maintenance                   = var.gke_daily_maintenance
  disable_hpa                         = var.gke_disable_hpa
  disable_lb                          = var.gke_disable_lb
  disable_dashboard                   = var.gke_disable_dashboard
  disable_network_policy              = var.gke_disable_network_policy
  enable_calico                       = var.gke_enable_calico
  authenticator_groups_security_group = var.gke_authenticator_groups_security_group
  init_nodes                          = var.gke_init_nodes

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service
}

## Extra resources

### Bucket for Prow
resource "google_storage_bucket" "prow_bucket" {
  name          = "${var.gcloud_project}-prow-artefacts"
  location      = var.prow_artefact_bucket_location
  force_destroy = true

  versioning {
    enabled = true
  }
}

### Service Account for Prow to write/read the artefacts in the bucket
resource "google_service_account" "prow_bucket_editor" {
  account_id   = "prow-bucket"
  display_name = "Service Account for the Prow artefact bucket"
}

### Set IAM for Prow to write/read the artefacts in the bucket
resource "google_storage_bucket_iam_member" "prow_bucket_editor" {
  bucket = google_storage_bucket.prow_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.prow_bucket_editor.email}"
}

### Key for the Prow bucket service account
resource "google_service_account_key" "prow_bucket_editor_key" {
  service_account_id = google_service_account.prow_bucket_editor.name
}

### Service Account for  Cert-Manager to create DNS entries
resource "google_service_account" "certmanager_dns_editor" {
  account_id   = "certmanager"
  display_name = "Service Account for CertManager to manage dns entries"
}

### Set IAM for  Cert-Manager to admin clouddns
resource "google_project_iam_member" "certmanager_dns_editor_role" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.certmanager_dns_editor.email}"
}

### Key for the Cert-Manager Service Account
resource "google_service_account_key" "certmanager_dns_editor_key" {
  service_account_id = google_service_account.certmanager_dns_editor.name
}

### Service Account for the Preemptible node killer
# https://github.com/estafette/estafette-gke-preemptible-killer
resource "google_service_account" "preemptible_killer" {
  account_id   = "preemptible-killer"
  display_name = "Service Account for the Preemptible Killer to zap pre emptible nodes before Google takes them away"
}

### Set IAM for preemptible-killer to zap nodes
resource "google_project_iam_member" "preemptible_killer_compute_admin" {
  role   = "roles/compute.admin"
  member = "serviceAccount:${google_service_account.preemptible_killer.email}"
}

### Set IAM for preemptible-killer to zap nodes
resource "google_project_iam_member" "preemptible_killer_container_admin" {
  role   = "roles/container.admin"
  member = "serviceAccount:${google_service_account.preemptible_killer.email}"
}
### Key for the Preemptible killer Service Account
resource "google_service_account_key" "preemptible_killer" {
  service_account_id = google_service_account.preemptible_killer.name
}

### Service Account for Terraform
resource "google_service_account" "prow_terraform" {
  account_id   = "prow-tf"
  display_name = "Service account for Prow to execute Terraform Google Provider Resources"
}

### Set IAM for Prow Terraform to edit the whole project
resource "google_project_iam_member" "prow_terraform" {
  role   = "roles/editor"
  member = "serviceAccount:${google_service_account.prow_terraform.email}"
}

### Key for the Prow TF Service Account
resource "google_service_account_key" "prow_terraform" {
  service_account_id = google_service_account.prow_terraform.name
}

# Removing the AWS user management - this is not directly related to this module 
# and it cleaner without it
#
# ### AWS Service Account for terraform 
# resource "aws_iam_user" "prow_terraform" {
#   count = var.create_aws_terraform_user == true ? 1 : 0
#   name = "tf_aws_service_account_${local.infra_id}"
#   tags = local.tags
# }

# ### AWS Service Account access key
# resource "aws_iam_access_key" "prow_terraform" {
#   count = var.create_aws_terraform_user == true ? 1 : 0
#   user = aws_iam_user.prow_terraform[count.index].name
# }

# ### AWS Service Account IAM policy
# resource "aws_iam_user_policy" "prow_terraform" {
#   count = var.create_aws_terraform_user == true ? 1 : 0
#   name = "tf_aws_service_account_${local.infra_id}"
#   user = aws_iam_user.prow_terraform[count.index].name

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "*",
#             "Resource": "*"
#         }
#     ]
# }
# EOF
# }

### DNS Zone for the Base Domain we are using
resource "google_dns_managed_zone" "cluster_zone" {
  name        = replace(var.base_domain, ".", "-")
  dns_name    = "${var.base_domain}."
  description = "${var.system} zone"
}

# resource "google_bigquery_dataset" "metering_dataset" {
#   dataset_id                  = "${var.name}_gke_metering_dataset"
#   friendly_name               = "${var.name}_gke_metering_dataset"
#   description                 = "GKE metering usage for cluster ${var.name}"
#   location                    = "EU"
#   default_table_expiration_ms = 3600000
#   delete_contents_on_destroy  = true
# }