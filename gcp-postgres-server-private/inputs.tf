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
  description = "Second Generation only. Configuration to increase storage size automatically."
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "The type of storage to use. Must be one of `PD_SSD` or `PD_HDD`."
  type        = string
  default     = "PD_SSD"
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

variable "machine_type" {
  description = "The machine type for the instances. See this page for supported tiers and pricing: https://cloud.google.com/sql/pricing"
  type        = string
}

variable "maintenance_track" {
  description = "Receive updates earlier (canary) or later (stable)."
  type        = string
  default     = "stable"
}

variable "availability_type" {
  description = "Can Be ZONAL or REGIONAL"
  type        = string
  default     = "REGIONAL"
}

variable "database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server"
  type        = list(any)

  default = [
   {
     name  = "max_connections"
     value = "800"
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
