variable "gcloud_region" {
  description = "Google Cloud region"
}

variable "gcloud_project" {
  description = "Name of the GKE project"
}
variable "gke_name" {
  default = "prow"
}

variable "system" {
  description = "The system name"
  default     = "testinfra"
}

# See: https://cloud.google.com/kubernetes-engine/docs/how-to/ip-aliases
variable "gke_node_cidr_range" {
  description = "VPC nodes CIDR range"
  default     = "10.101.0.0/22"
}

variable "gke_pod_cidr_range" {
  description = "VPC pods CIDR range"
  default     = "172.20.0.0/14"
}

variable "gke_service_cidr_range" {
  description = "VPC services CIDR range"
  default     = "10.200.0.0/16"
}

variable "gke_master_cidr_range" {
  description = "CIDR range for masters"
  default     = "172.16.0.32/28"
}

variable "gke_node_scopes" {
  description = "The GKE node scopes"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_write",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite"
  ]
}

variable "gke_auth_cidr_blocks" {
  type        = list
  description = "Authorized cidr blocks for the API"
  default = [
    {
      cidr_block   = "0.0.0.0/0",
      display_name = "everyone"
    }
  ]
}

variable "gke_kubernetes_version" {
  description = "Minimum k8s master version"
}

variable "gke_machine_type" {
  description = "Instance type for the primary pool of workers"
  default     = "n2-standard-2"
}

variable "gke_big_machine_type" {
  description = "Instance type for the beefier pool of workers"
  default     = "n2-standard-4"
}

variable "gke_machine_disk_size" {
  description = "Disk size for the primary pool of workers"
  default     = 50
}

variable "gke_machine_is_preemptible" {
  description = "If true use preemptible instances"
  default     = true
}

variable "gke_min_nodes" {
  description = "Min number of workers"
  default     = 0
}

variable "gke_max_nodes" {
  description = "Max number of workers"
  default     = 4
}

variable "imagebuilder_machine_type" {
  description = "Instance type for the image builder pool of workers"
  default     = "n2-standard-4"
}

variable "imagebuilder_machine_disk_type" {
  description = "Disk size for the image builder pool of workers"
  default     = "pd-ssd"
}

variable "imagebuilder_machine_disk_size" {
  description = "Disk size for the image builder pool of workers"
  default     = 100
}

variable "imagebuilder_machine_is_preemptible" {
  description = "If true use preemptible instances"
  default     = true
}


variable "imagebuilder_min_nodes" {
  description = "Min number of workers"
  default     = 0
}

variable "imagebuilder_max_nodes" {
  description = "Max number of workers"
  default     = 4
}

variable "gke_daily_maintenance" {
  default = "02:00"
}

variable "gke_disable_hpa" {
  default = true
}

variable "gke_disable_lb" {
  default = true
}

variable "gke_disable_dashboard" {
  default = true
}

variable "gke_disable_network_policy" {
  default = false
}

variable "gke_enable_calico" {
  default = true
}

variable "gke_init_nodes" {
  default = 1
}

variable "gke_authenticator_groups_security_group" {
}

variable "prow_artefact_bucket_location" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "google_apis" {
  type = set(string)
  default = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "iamcredentials.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "cloudapis.googleapis.com",
    "containerregistry.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "dns.googleapis.com"
  ]
}

variable "logging_service" {
  default = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  default = "monitoring.googleapis.com/kubernetes"
}