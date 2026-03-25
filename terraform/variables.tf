variable "project" {}
variable "region" {}
variable "zone" {}

variable "ssh_user" {
  default = "danz"
}

variable "public_key_path" {
  default = "C:/Users/Danz/.ssh/id_ed25519.pub"
}

variable "github_token" {
  type = string
}