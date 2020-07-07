terraform {
  required_version = ">= 0.12"
  
  required_providers {
    google = ">= 3.27"
    random = ">= 2.2"
    vault  = ">= 2.1"
  }
}