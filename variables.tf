variable "image" {
  type        = map(any)
  description = "docker image"
  default = {
    "dev"  = "nodered/node-red:latest"
    "prod" = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = map
  # sensitive = true
  validation {
    condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1980
    error_message = "You have used invalid port, the external port must be a range 1980 - 65535."
  }

    validation {
    condition     = max(var.ext_port["prod"]...) < 1980 && min(var.ext_port["prod"]...) >= 1880
    error_message = "You have used invalid port, the external port must be a range 1880 - 1979."
  }
}

variable "int_port" {
  type    = number
  default = 1880
  validation {
    condition     = var.int_port == 1880
    error_message = "You have used invalid port, the internal port must be 1880."
  }
}

locals {
  count_num = length(lookup(var.ext_port, terraform.workspace))
}