terraform {
  backend "gcs" {
    bucket      = "poc-preview-api-cloud-run"
    prefix      = "terraform/state"
    credentials = "./../gcp.json"
  }
}


provider "google" {
  project = "poc-preview-api" 
  region  = "us-east4" 
  credentials = "./../gcp.json"
}

# Deploy the Cloud Run service with environment variables
resource "google_cloud_run_v2_service" "preview_service" {
  name     = "my-preview-app-${var.hash}"
  location = "us-east4"   # Replace with your desired region

  template {
      containers {
        image = "${var.docker_image}"  # Replace with your container image
        ports {
          container_port = 8080  # Define the port your app listens on
        }

        # Define environment variables for the container
        # env = [
        #   {
        #     name  = "ENVIRONMENT"
        #     value = "preview"  # Value for the environment variable
        #   },
        #   {
        #     name  = "VERSION"
        #     value = "v1"
        #   },
        #   {
        #     name  = "DATABASE_URL"
        #     value = "postgres://db.example.com:5432"
        #   }
        # ]
      }
  }


  traffic {
    revision        = true
    percent         = 100
  }

  # This block allows unauthenticated access to the service
  annotations = {
    "run.googleapis.com/ingress" = "all"
  }

}


# Allow unauthenticated access (IAM policy binding)
resource "google_cloud_run_service_iam_member" "unauthenticated" {
  service = google_cloud_run_service.preview_service.name
  location = google_cloud_run_service.preview_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"  # This allows all users, including unauthenticated ones
}


