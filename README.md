# prow-gke-terraform

## Overview

This is a terraform module for creating a prow k8s cluster running in GKE.

## Features

- Runs in GKE
- Runs on private nodes 
- Managed Control Plane and Nodes by GKE
- Automatic control plane upgrades
- Automatic node updades
- Cluster scales up and down as needed
- Injected all needed secrets to install Prow
- Setup GSuite integration with RBAC

## Usage

```
module "prow-cluster" {
  source = "git@github.com:ouzi-dev/prow-gke-terraform.git?ref=v0.1"

  gcloud_region              = var.gcloud_region
  gcloud_project             = var.gcloud_project
  gke_kubernetes_version     = var.gke_kubernetes_version
  gke_authenticator_groups_security_group = var.gke_authenticator_groups_security_group

  base_domain = var.base_domain
  github_org  = var.github_org

  prow_artefact_bucket_location = var.prow_artefact_bucket_location
}
```

