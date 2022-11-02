resource "null_resource" "build" {
  provisioner "local-exec" {
    command = "make build"
    working_dir = "${path.root}/../app"
    environment = {
        TAG = "latest"
        REGISTRY_ID = "089370973671"
        REPOSITORY_REGION = "eu-central-1"
        APP_NAME = "kebap"
        ENV_NAME = "project"
    }
  }
}