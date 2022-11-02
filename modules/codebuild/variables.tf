variable "vpcId" {}

variable "iamRoleTreti" {}

variable "privateSubnet" {}

variable "region" {}

variable "buildSpecFile" {
    default = "buildspec.yml"
}

variable "awsacc" {
    default = ""
}

variable "token" {
    default = ""
}
