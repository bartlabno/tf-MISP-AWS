variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "owner" {
  type = string
}

variable "profile" {
  type = string
}

variable "image_version" {
  type = string
}

variable "vpc" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "office_cidr" {
  default = "51.149.8.0/24"
}