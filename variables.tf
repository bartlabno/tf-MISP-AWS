variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "owner" {
  type = string
}

variable "image_version" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "office_cidr" {
  default = "51.149.8.0/24"
}

variable "block_cidr" {
  type = string
}