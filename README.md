## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | ~> 1.43 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | 1.43.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [grafana_rule_group.rule_group_cloudflared_tunnel_request_errors](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_cloudsql_cpu](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_cloudsql_disk](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_cluster_cpu_usage](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_cluster_filesystem](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_cluster_memory](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_container_cpu_usage](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_container_memory_usage](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_failed_prometheus_pod](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_ingress_response_time](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_oom_container_restarts](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_pod_cpu_usage](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_pod_memory_usage](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_pod_terminated](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_prometheus_cpu_usage](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_prometheus_error_rate](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_prometheus_memory_usage](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_prometheus_restarts](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_promtail_cpu_usage](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_promtail_memory_usage](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_rule_group.rule_group_promtail_unavailable_pods](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_cloudsql"></a> [enable\_cloudsql](#input\_enable\_cloudsql) | Enable CloudSQL Disk and CPU Alerts | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_folder_uid"></a> [folder\_uid](#input\_folder\_uid) | Grafana Folder UID | `string` | n/a | yes |
| <a name="input_gcp_datasource_name"></a> [gcp\_datasource\_name](#input\_gcp\_datasource\_name) | GCP Datasource Name | `string` | n/a | yes |
| <a name="input_gcp_datasource_uid"></a> [gcp\_datasource\_uid](#input\_gcp\_datasource\_uid) | GCP Datasource UID | `string` | n/a | yes |
| <a name="input_loki_datasource_uid"></a> [loki\_datasource\_uid](#input\_loki\_datasource\_uid) | Loki Datasource UID | `string` | n/a | yes |
| <a name="input_notification_channel"></a> [notification\_channel](#input\_notification\_channel) | Notification Channel | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Organization ID | `string` | n/a | yes |
| <a name="input_product_name"></a> [product\_name](#input\_product\_name) | Product Name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name | `string` | n/a | yes |
| <a name="input_prom_datasource_uid"></a> [prom\_datasource\_uid](#input\_prom\_datasource\_uid) | Prometheus Datasource UID | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Service Name | `string` | n/a | yes |

## Outputs

No outputs.
