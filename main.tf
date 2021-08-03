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
  count   = local.count_num
  length  = 4
  upper   = false
  special = false
}

resource "docker_image" "nodered_image" {
  name = lookup(var.image, var.env)
}

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir nodered_vol || true && chown -R 1000:1000 nodered_vol/"
  }
}

resource "docker_container" "nodered_container" {
  count = local.count_num
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/nodered_vol"
  }
}

# resource "docker_container" "nodered_container2" {
#   name  = "nodered-71xr"
#   image = docker_image.nodered_image.latest
# }
