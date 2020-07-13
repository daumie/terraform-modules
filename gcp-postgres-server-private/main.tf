# Prepare locals
locals {
  default_db_user_name = "postgres"
}

resource "random_id" "db_suffix" {
  byte_length = 8
}

# Create the postgres database instance in workspace ( dev, prod1 or prod-asia)

resource "google_sql_database_instance" "this" {

  provider = google-beta

  name             = "${var.database_instance_name_stem}-${random_id.db_suffix.hex}"
  project          = data.google_project.this.project_id
  region           = var.region
  database_version = var.database_version

  depends_on = [null_resource.dependency_getter]


  settings {
    tier              = var.machine_type
    activation_policy = var.activation_policy
    availability_type = var.availability_type
    disk_autoresize   = var.disk_autoresize

    disk_size = var.disk_size
    disk_type = var.disk_type

    ip_configuration {
      ipv4_enabled    = true
      private_network = data.google_compute_network.this.self_link
    }

    backup_configuration {
      binary_log_enabled = true
      enabled            = true
      start_time         = var.backup_start_time_utc
    }

    location_preference {
      zone = var.database_zone
    }

    maintenance_window {
      day          = var.maintenance_day
      hour         = var.maintenance_hour
      update_track = var.maintenance_track
    }

    dynamic "database_flags" {

      for_each = var.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

  }


  provisioner "local-exec" {
    command = <<-EOT
      wget                                                           \
      --no-verbose                                                   \
      --header "Authorization: Bearer $${ACCESS_TOKEN}"              \
      --header "Content-Type: application/json"                      \
      --output-document -                                            \
      --method DELETE                                                \
      --body-data "{\"name\": \"$${DEFAULT_USER}\", \"host\": \"\"}" \
      "$${GCP_URL}" || exit 1;
    EOT

    environment = {
      ACCESS_TOKEN = data.google_client_config.this.access_token
      DEFAULT_USER = local.default_db_user_name
      GCP_URL      = "https://www.googleapis.com/sql/v1beta4/projects/${data.google_project.this.project_id}/instances/${google_sql_database_instance.this.name}/users?host=&name=${local.default_db_user_name}"
    }
  }

  # Default timeouts are 10 minutes, which in most cases should be enough.
  # Sometimes the database creation can, however, take longer, so we
  # increase the timeouts slightly.
  timeouts {
    create = var.resource_timeout
    delete = var.resource_timeout
    update = var.resource_timeout
  }
}

# ------------------------------------------------------------------------------
# SET MODULE DEPENDENCY RESOURCE
# This works around a terraform limitation where we can not specify module dependencies natively.
# See https://github.com/hashicorp/terraform/issues/1178 for more discussion.
# By resolving and computing the dependencies list, we are able to make all the resources in this module depend on the
# resources backing the values in the dependencies list.
# ------------------------------------------------------------------------------

resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}



resource "random_password" "default_password" {
  length  = 32
  special = false
}

resource "vault_generic_secret" "default_password" {
  path = var.default_postgres_user_password_vault_path

  data_json = <<-EOT
    {
      "value": "${random_password.default_password.result}"
    }
  EOT
}

resource "google_sql_user" "default" {
  provider = google

  instance   = google_sql_database_instance.this.name
  name       = local.default_db_user_name
  password   = random_password.default_password.result
  project    = data.google_project.this.project_id
  depends_on = [google_sql_database_instance.this]
}
