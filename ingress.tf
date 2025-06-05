resource "grafana_rule_group" "rule_group_ingress_response_time" {
  count            = var.enable_ingress_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Response Time alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Response Time alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"datasource\":{\"type\":\"prometheus\",\"uid\":\"${var.prom_datasource_uid}\"},\"exemplar\":true,\"expr\":\"histogram_quantile(0.5, \\n  sum by (le, ingress) (\\n    rate(nginx_ingress_controller_request_duration_seconds_bucket{env=\\\"${var.environment}\\\"}[10m])\\n))\",\"interval\":\"\",\"legendFormat\":\"50th% - {{ingress}}\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[30],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      message = "${var.product_name} (${var.environment}): Response Times High"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_cloudflared_tunnel_request_errors" {
  count            = var.enable_ingress_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "Tunnel request errors (1m rate) alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "Tunnel request errors (1m rate) alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"sum(rate(cloudflared_tunnel_request_errors{env=\\\"${var.environment}\\\"} [1m]))\",\"interval\":\"\",\"legendFormat\":\"Error rate\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[10],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"avg\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}) cloudflared is reporting errors.\n\nNOTE: If Engineering is doing a release - sometimes this triggers - if they're not doing a release it's bad."
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
