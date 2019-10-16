# prow-gke-terraform

## Overview

This is a terraform module for creating a prow k8s cluster running in GKE.

## Features

- Runs in GKE, with private nodes 
- Managed Control Plan and Nodes by GKE
- Automatic control plan upgrades
- Automatic node updades
- Cluster scales up and down as needed
- Injected all needed secrets to install Prow
- Setup GSuite integration with RBAC
- 

## Usage

```
module "prow-cluster" {
  source = "git@github.com:ouzi-dev/prow-gke-terraform.git?ref=v0.1"

  gcloud_region              = var.gcloud_region
  gcloud_project             = var.gcloud_project
  gke_kubernetes_version     = var.gke_kubernetes_version
  dockerconfig_credstash_key = var.dockerconfig_credstash_key

  base_domain = var.base_domain
  github_org  = var.github_org

  slack_bot_token_credstash_key = var.slack_bot_token_credstash_key
  prow_artefact_bucket_location = var.prow_artefact_bucket_location

  gke_authenticator_groups_security_group = var.gke_authenticator_groups_security_group
}
```

## Secrets

We leverage [credstash](https://github.com/fugue/credstash) for managing secrets and therefore this module will require you to specify credstash keys