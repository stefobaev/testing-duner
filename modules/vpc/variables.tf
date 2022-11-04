variable "region" {
  description = "name of region"
  default = "eu-central-1"
}

variable "aZone1" {
  description = "Availabbiliti zone 1"
  default = "eu-central-1a"
}

variable "aZone2" {
  description = "Availabbiliti zone 2"
  default = "eu-central-1b"
}

variable "cidr_block_vpc" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "default_cidr_block" {
  description = "CIDR block defoult"
  default     = "0.0.0.0/0"
}

variable "publicSubnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    tags                    = map(string)
  }))
  default = {
    Public1 = {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "eu-central-1a"
      map_public_ip_on_launch = true
      tags = {
        "Name" = "publicSubnet1"
      }
    }
    Public2 = {
      cidr_block              = "10.0.100.0/24"
      availability_zone       = "eu-central-1b"
      map_public_ip_on_launch = true
      tags = {
        "Name" = "publicSubnet2"
      }
    }
  }
}

variable "privateSubnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    tags                    = map(string)
  }))
  default = {
    "Private1" = {
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "eu-central-1a"
      map_public_ip_on_launch = false
      tags = {
        "Name" = "privateSubnet1"
      }
    }
    "Private2" = {
      cidr_block              = "10.0.200.0/24"
      availability_zone       = "eu-central-1b"
      map_public_ip_on_launch = false
      tags = {
        "Name" = "privateSubnet2"
      }
    }
  }
}

variable "publicRouteTable" {
  type = map(object({
    cidr_block = string
    tags       = map(string)
  }))
  default = {
    Public1 = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "publicRouteTable"
      }
    }
    Public2 = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "publicRouteTable"
      }
    }
  }
}

variable "privateRouteTable" {
  type = map(object({
    cidr_block = string
    tags       = map(string)
  }))
  default = {
    Private1 = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "privateRouteTable"
      }
    }
    Private2 = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "privateRouteTable"
      }
    }
  }
}