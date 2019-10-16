# prow-gke-terraform

## Overview

This is a terraform module for creating a prow k8s cluster running in GKE.

## Secrets

We leverage [credstash](https://github.com/fugue/credstash) for managing secrets and therefore this module will require you to specify credstash keys