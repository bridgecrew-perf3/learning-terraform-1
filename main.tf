terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.14.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "random_string" "random" {
  count   = var.count_num
  length  = 4
  upper   = false
  special = false
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir nodered_vol || true && chown -R 1000:1000 nodered_vol/"
  }
}

resource "docker_container" "nodered_container" {
  count = var.count_num
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port
  }
  volumes {
    container_path = "/data"
    host_path = "/home/salim/terraform/docker/nodered_vol"
  }
}

# resource "docker_container" "nodered_container2" {
#   name  = "nodered-71xr"
#   image = docker_image.nodered_image.latest
# }
