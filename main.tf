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
  count   = 2
  length  = 4
  upper   = false
  special = false
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 1880
  }
}

# resource "docker_container" "nodered_container2" {
#   name  = join("-",["nodered",random_string.random2.result])
#   image = docker_image.nodered_image.latest
#   ports {
#     internal = 1880
#     #external = 1880
#   }
# }

output "Container_names" {
  value       = docker_container.nodered_container[*].name
  description = "This are container names."
}

# output "Container_name2" {
#   value       = docker_container.nodered_container[1].name
#   description = "This is container name for nodered_container2."
# }

output "IP_address_of_the_containers" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "This are containers IP addresses."
}

# output "IP_address_nodered-container2" {
#   value       = join(":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external])
#   description = "This is an IP address and external port of the container."
# }

