# GCloud outputs
output "gcloud_region" {
  value = var.gcloud_region
}

output "gcloud_project" {
  value = var.gcloud_project
}

# GKE outputs

output "gke_name" {
  value = local.gke_name
}

output "cluster_ca_certificate" {
  value = modules.gke-cluster.cluster_ca_certificate
  sensitive = true
}

## Prow related outputs
output "prow_bucket_svc_account_key" {
  value     = google_service_account_key.prow_bucket_editor_key.private_key
  sensitive = true
}

output "prow_webhook_hmac_token" {
  value     = random_string.hmac_token.result
  sensitive = true
}

output "prow_github_bot_token" {
  value     = data.credstash_secret.github_bot_token.value
  sensitive = true
}

output "prow_github_bot_ssh_key" {
  value     = data.credstash_secret.github_bot_ssh_key.value
  sensitive = true
}

output "prow_github_oauth_client_id" {
  value     = data.credstash_secret.prow_github_oauth_client_id.value
  sensitive = true
}

output "prow_github_oauth_client_secret" {
  value     = data.credstash_secret.prow_github_oauth_client_secret.value
  sensitive = true
}

output "prow_github_oauth_config" {
  value = templatefile("${path.module}/templates/_prow_github_oauth_config.yaml",
    {
      client_id          = data.credstash_secret.prow_github_oauth_client_id.value,
      client_secret      = data.credstash_secret.prow_github_oauth_client_secret.value,
      redirect_url       = "https://${local.prow_base_url}/github-login/redirect",
      final_redirect_url = "https://${local.prow_base_url}/pr",
    }
  )
  sensitive = true
}

output "prow_terraform_gcloud_svc_account_key" {
  value     = google_service_account_key.prow_terraform.private_key
  sensitive = true
}

output "prow_terraform_aws_svc_account_access_key_id" {
  value     = aws_iam_access_key.prow_terraform.id
  sensitive = true
}

output "prow_terraform_aws_svc_account_secret_access_key" {
  value     = aws_iam_access_key.prow_terraform.secret
  sensitive = true
}

output "prow_artefacts_bucket_name" {
  value = google_storage_bucket.prow_bucket.name
}

output "prow_base_url" {
  value = local.prow_base_url
}

output "prow_github_org" {
  value = var.github_org
}

## Cert-Manager outputs
output "certmanager_svc_account_key" {
  value     = google_service_account_key.certmanager_dns_editor_key.private_key
  sensitive = true
}

output "valuesyaml" {
  value = base64encode(templatefile(
    "${path.module}/templates/_prow_values.yaml",
    {
      gcloud_region                                    = var.gcloud_region,
      gcloud_project                                   = var.gcloud_project,
      gke_name                                         = local.gke_name,
      gke_authenticator_groups_security_group          = var.gke_authenticator_groups_security_group,
      prow_terraform_gcloud_svc_account_key            = google_service_account_key.prow_terraform.private_key,
      prow_terraform_aws_svc_account_access_key_id     = base64encode(aws_iam_access_key.prow_terraform.id),
      prow_terraform_aws_svc_account_secret_access_key = base64encode(aws_iam_access_key.prow_terraform.secret),
      prow_base_url                                    = local.prow_base_url,
      prow_bucket_svc_account_key                      = google_service_account_key.prow_bucket_editor_key.private_key,
      prow_webhook_hmac_token                          = base64encode(random_string.hmac_token.result),
      prow_cookie_secret                               = base64encode(random_string.prow_cookie_secret.result),
      prow_artefacts_bucket_name                       = google_storage_bucket.prow_bucket.name,
      prow_github_bot_token                            = base64encode(data.credstash_secret.github_bot_token.value),
      prow_github_bot_ssh_key                          = base64encode(data.credstash_secret.github_bot_ssh_key.value),
      prow_github_org                                  = var.github_org,
      oauth_client_id                                  = base64encode(data.credstash_secret.prow_cluster_github_oauth_client_id.value),
      oauth_client_secret                              = base64encode(data.credstash_secret.prow_cluster_github_oauth_client_secret.value),
      oauth_cookie_secret                              = base64encode(random_string.prow_cluster_github_oauth_cookie_secret.result),
      prow_github_oauth_config = base64encode(
        templatefile("${path.module}/templates/_prow_github_oauth_config.yaml",
          {
            client_id          = data.credstash_secret.prow_github_oauth_client_id.value,
            client_secret      = data.credstash_secret.prow_github_oauth_client_secret.value,
            redirect_url       = "https://${local.prow_base_url}/github-login/redirect",
            final_redirect_url = "https://${local.prow_base_url}/pr",
          }
        )
      ),
      prow_redirect_url           = "${local.prow_base_url}/github-login/redirect",
      prow_final_redirect_url     = "${local.prow_base_url}/pr",
      certmanager_svc_account_key = google_service_account_key.certmanager_dns_editor_key.private_key
      slack_token                 = base64encode(data.credstash_secret.slack_bot_token.value)
      dockerconfig                = base64encode(data.credstash_secret.dockerconfig.value)
    }
  ))
  sensitive = true
}