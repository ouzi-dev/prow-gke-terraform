# GKE outputs

output "cluster_ca_certificate" {
  value = module.gke-cluster.cluster_ca_certificate
  sensitive = true
}

## Prow related outputs
output "prow_bucket_svc_account_key" {
  value     = google_service_account_key.prow_bucket_editor_key.private_key
  sensitive = true
}

output "prow_terraform_gcloud_svc_account_key" {
  value     = google_service_account_key.prow_terraform.private_key
  sensitive = true
}

# output "prow_terraform_aws_svc_account_access_key_id" {
#   value     = aws_iam_access_key.prow_terraform[*].id
#   sensitive = true
# }

# output "prow_terraform_aws_svc_account_secret_access_key" {
#   value     = aws_iam_access_key.prow_terraform[*].secret
#   sensitive = true
# }

output "prow_artefacts_bucket_name" {
  value = google_storage_bucket.prow_bucket.name
}

## Cert-Manager outputs
output "certmanager_svc_account_key" {
  value     = google_service_account_key.certmanager_dns_editor_key.private_key
  sensitive = true
}