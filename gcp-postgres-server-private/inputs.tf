variable "availability_type" {
  type = string

  default = "REGIONAL"
}

variable "backup_enabled" {
  type = bool

  default = true
}

variable "backup_start_time_utc" {
  type = string

  default = "00:00"
}

variable "database_instance_name_stem" {
  type = string
}

variable "database_version" {
  type = string

  default = "POSTGRES_9_6"
}

variable "default_postgres_user_password_vault_path" {
  type = string
}

variable "disk_autoresize" {
  type = bool

  default = true
}

variable "disk_size_gb" {
  type = number

  default = 10
}

variable "disk_type" {
  type = string

  default = "PD_SSD"
}

variable "instance_cores" {
  type = number

  default = 1
}

variable "instance_memory_mbs" {
  type = number

  default = 3840
}

variable "maintenance_day" {
  type = number

  default = 7
}

variable "maintenance_hour" {
  type = number

  default = 0
}

variable "network_name" {
  type = string
}

data "google_compute_network" "this" {
  provider = google

  name    = var.network_name
  project = data.google_project.this.project_id
}

variable "project_id" {
  type = string
}

data "google_project" "this" {
  provider = google

  project_id = var.project_id
}

variable "region" {
  type = string

  default = "us-west1"
}

data "google_client_config" "this" {
  provider = google
}
variable "activation_policy" {
  description = "This specifies when the instance should be active. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "maintenance_track" {
  description = "Receive updates earlier (canary) or later (stable)."
  type        = string
  default     = "stable"
}

variable "database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server"
  type        = list(any)

  default = [
   {
     name  = "max_connections"
     value = "1200"
   },
  ]
}
variable "database_zone" {
  description = "Preferred zone for the master instance (e.g. 'us-central1-a'). 'region'. If null, Google will auto-assign a zone."
  type        = string
  default     = null
}


variable "resource_timeout" {
  description = "Timeout for creating, updating and deleting database instances. Valid units of time are s, m, h."
  type        = string
  default     = "20m"
}
