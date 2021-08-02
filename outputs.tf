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
  sensitive   = true
}

# output "IP_address_nodered-container2" {
#   value       = join(":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external])
#   description = "This is an IP address and external port of the container."
# }