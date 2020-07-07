output "google_sql_database_instance_name" {
  value = google_sql_database_instance.this.name
}

output "google_sql_database_instance_private_ip" {
  value = google_sql_database_instance.this.private_ip_address
}

