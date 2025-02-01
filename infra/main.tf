terraform {
  backend "gcs" {
    bucket      = "poc-preview-api-cloud-run"
    prefix      = "terraform/state"
    credentials = "./gcp_credential.json"
  }
}


provider "google" {
  project = "poc-preview-api" 
  region  = "us-east4" 
  credentials = file("./../gcp.json")
         
}

# Deploy the Cloud Run service with environment variables
resource "google_cloud_run_service" "preview_service" {
  name     = "my-preview-app"
  location = "us-east4"   # Replace with your desired region

  template {
    spec {
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
  }

  traffic {
    latest_revision = true
    percent         = 100
  }
}

output "cloud_run_url" {
  value = google_cloud_run_service.preview_service.status[0].url
}

