# --- root/variables.tf ---

variable "access_ip" {
  type = string
}

variable "db_name" {
  type = string
}

variable "dbuser" {
  type      = string
  sensitive = true
}

variable "secret_name" {
  type      = string
  sensitive = true
}

variable "instance_type"{
  type      = string
}

variable "key_name"{
  type      = string

} 

variabe "user_name"{
  type      = string
}