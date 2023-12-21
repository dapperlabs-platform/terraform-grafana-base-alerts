variable "folder_uid" {
  description = "Grafana Folder UID"
  type        = string
}

variable "prom_datasource_uid" {
  description = "Prometheus Datasource UID"
  type        = string
}

variable "loki_datasource_uid" {
  description = "Loki Datasource UID"
  type        = string
}

variable "gcp_datasource_uid" {
  description = "GCP Datasource UID"
  type        = string
}

variable "gcp_datasource_name" {
  description = "GCP Datasource Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "product_name" {
  description = "Product Name"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "notification_channel" {
  description = "Notification Channel"
  type        = string
}

variable "service_name" {
  description = "Service Name"
  type        = string
}

variable "org_id" {
  description = "Organization ID"
  type        = string
}

variable "enable_cloudsql" {
  description = "Enable CloudSQL Disk and CPU Alerts"
  type        = bool
  default     = false
}
