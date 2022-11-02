resource "null_resource" "build" {
  provisioner "local-exec" {
    command = "make build"
    working_dir = "../../app"
    environment = {
        TAG = "latest"
        REGISTRY_ID = "089370973671"
        REPOSITORY_REGION = "eu-central-1"
        APP_NAME = "firstDemo"
        ENV_NAME = "project"
    }
  }
}