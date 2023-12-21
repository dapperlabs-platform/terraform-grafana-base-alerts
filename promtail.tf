resource "grafana_rule_group" "rule_group_promtail_cpu_usage" {
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Promtail CPU usage - Top 5 alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Promtail CPU usage - Top 5 alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"sum by(pod, container) (rate(container_cpu_usage_seconds_total{container=\\\"promtail\\\", env=\\\"${var.environment}\\\"}[5m]))\\n/ on (pod, container) kube_pod_container_resource_limits{resource=\\\"cpu\\\", container=\\\"promtail\\\", env=\\\"${var.environment}\\\"}\",\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0.88],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "OK"
    exec_err_state = "Alerting"
    for            = "10m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High CPU Usage - Promtail"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_promtail_memory_usage" {
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Promtail memory usage - Top 5 alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Promtail memory usage - Top 5 alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"topk(5,container_memory_working_set_bytes{namespace=\\\"sre\\\", container=\\\"promtail\\\", env=\\\"${var.environment}\\\"}\\n/ on (pod)\\ncontainer_spec_memory_limit_bytes{namespace=\\\"sre\\\", container=\\\"promtail\\\", env=\\\"${var.environment}\\\"})\",\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0.85],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    for            = "10m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High Memory Usage - Promtail"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}

resource "grafana_rule_group" "rule_group_promtail_unavailable_pods" {
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Unavailable promtail pods alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Unavailable promtail pods alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"kube_daemonset_status_desired_number_scheduled{env=\\\"${var.environment}\\\", daemonset=\\\"promtail\\\"} - kube_daemonset_status_current_number_scheduled{env=\\\"${var.environment}\\\", daemonset=\\\"promtail\\\"}\",\"interval\":\"\",\"legendFormat\":\"{{env}}\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    for            = "10m"
    annotations = {
      message = "${var.product_name} (${var.environment}): Unavailable Promtail Pods"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
