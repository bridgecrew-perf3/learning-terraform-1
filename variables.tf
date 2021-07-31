variable "ext_port" {
  type    = number
  sensitive = true
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
