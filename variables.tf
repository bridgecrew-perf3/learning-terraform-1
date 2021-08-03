variable "env" {
  type        = string
  description = "environment to deploy to."
  default     = "dev"
}

variable "image" {
  type        = map(any)
  description = "docker image"
  default = {
    "dev"  = "nodered/node-red:latest"
    "prod" = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = list(any)
  # sensitive = true
  validation {
    condition     = max(var.ext_port...) <= 65535 && min(var.ext_port...) > 0
    error_message = "You have used invalid port, the external port must be a range 0 - 65535."
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
  count_num = length(var.ext_port)
}