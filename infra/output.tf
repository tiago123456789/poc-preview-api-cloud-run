

output "cloud_run_url" {
  value = google_cloud_run_service.preview_service.uri
}