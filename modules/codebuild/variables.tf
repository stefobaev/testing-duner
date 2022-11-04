variable "vpcId" {}

variable "iamRoleTreti" {}

variable "privateSubnet" {}

variable "region" {}

variable "github_oauth_token" {}

variable "buildSpecFile" {
    default = "project/config/buildspec.yml"
}

variable "awsacc" {
    default = "089370973671"
}