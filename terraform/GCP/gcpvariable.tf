variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "vm_name" {
  description = "The name of the Vm to create"
  type        = string
}

variable "zone" {
  description = "Cloud Run service deployment location"
  type        = string
}

variable "machine_type" {
  description = "machine_type to deploy"
  type        = string
}

variable "image" {
  description = "machine_type to deploy"
  type        = string
  default     = "debian-cloud/debian-9"
}

variable "vpc_network_name" {
  description = "vpc_network_name to deploy"
  type        = string
}

variable "auto_create_subnetworks" {
  description = "auto_create_subnetworks"
  type        = bool
  default     = true
}
