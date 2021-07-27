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
  length = 4
  upper = false
  special = false
}

resource "random_string" "random2" {
  length = 4
  upper = false
  special = false
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
  name  = join("-",["nodered",random_string.random.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 1880
  }
}

resource "docker_container" "nodered_container2" {
  name  = join("-",["nodered",random_string.random2.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 1880
  }
}

output "Container_name" {
  value       = docker_container.nodered_container.name
  description = "This is container name for nodered_container."
}

output "Container_name2" {
  value       = docker_container.nodered_container2.name
  description = "This is container name for nodered_container2."
}







output "IP_address_nodered-container" {
  value       = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
  description = "This is an IP address and external port of the container."
}

output "IP_address_nodered-container2" {
  value       = join(":", [docker_container.nodered_container2.ip_address, docker_container.nodered_container2.ports[0].external])
  description = "This is an IP address and external port of the container."
}

