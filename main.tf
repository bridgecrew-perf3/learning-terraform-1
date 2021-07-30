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

variable "ext_port" {
  type    = number
  default = 1880
    validation {
      condition = var.ext_port <= 65535 && var.ext_port > 0
      error_message = "You have used invalid port, the external port must be a range 0 - 65535."
    }
}

variable "int_port" {
  type    = number
  default = 1880
    validation {
      condition = var.int_port == 1880
      error_message = "You have used invalid port, the internal port must be 1880."
    }
}

variable "count_num" {
  type    = number
  default = 1
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

resource "docker_container" "nodered_container" {
  count = var.count_num
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port
  }
}

# resource "docker_container" "nodered_container2" {
#   name  = "nodered-71xr"
#   image = docker_image.nodered_image.latest
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

