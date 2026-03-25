provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "vm" {
  source = "./modules/vm"

  name         = "terraform-ubuntu"
  machine_type = "e2-standard-2"
  zone         = var.zone

  ssh_user     = var.ssh_user
  public_key   = file(var.public_key_path)

  github_token = var.github_token
}