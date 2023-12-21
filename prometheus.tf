resource "grafana_rule_group" "rule_group_failed_prometheus_pod" {
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Failed prometheus pod alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Failed prometheus pod alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"kube_deployment_status_replicas_unavailable{env=\\\"${var.environment}\\\", deployment=\\\"prometheus-server\\\"}\",\"interval\":\"\",\"legendFormat\":\"{{pod}}\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"avg\"}}]}"
    }

    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    for            = "10m"
    annotations = {
      message = "${var.product_name} (${var.environment}): Failed Prometheus Pod"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_prometheus_cpu_usage" {
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Prometheus CPU Usage % alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Prometheus CPU Usage % alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"sum by(pod, env, container) (rate(container_cpu_usage_seconds_total{env=\\\"${var.environment}\\\", container=\\\"prometheus-server\\\"}[5m]))\\n/ on (pod, env, container) kube_pod_container_resource_limits{env=\\\"${var.environment}\\\", resource=\\\"cpu\\\", container=\\\"prometheus-server\\\"}\",\"interval\":\"\",\"legendFormat\":\"{{env}}/{{ pod }}\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0.85],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"avg\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    for            = "10m"
    annotations = {
      message = "${var.product_name} (${var.environment}): CPU Usage High - Prometheus"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_prometheus_memory_usage" {
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Prometheus Memory Usage % alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Prometheus Memory Usage % alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"container_memory_working_set_bytes{env=\\\"${var.environment}\\\", namespace=\\\"sre\\\", container=\\\"prometheus-server\\\"}\\n/ on (pod,env,name)\\ncontainer_spec_memory_limit_bytes{namespace=\\\"sre\\\", container=\\\"prometheus-server\\\"}\",\"instant\":false,\"interval\":\"\",\"legendFormat\":\"{{env}}/{{pod}}\",\"refId\":\"A\"}"
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
      message = "${var.product_name} (${var.environment}): Memory Usage High - Prometheus"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_prometheus_restarts" {
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Prometheus Restarts alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Prometheus Restarts alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"floor(increase(kube_pod_container_status_restarts_total{env=\\\"${var.environment}\\\", container=\\\"prometheus-server\\\"} [2m]))\",\"interval\":\"\",\"legendFormat\":\"{{env}}\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"max\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    for            = "10m"
    annotations = {
      message = "${var.product_name} (${var.environment}): Prometheus Restarts"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_prometheus_error_rate" {
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Prometheus error rate alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Prometheus error rate alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.loki_datasource_uid
      model          = "{\"expr\":\"sum by(env,pod) (rate({env=\\\"${var.environment}\\\", container=\\\"prometheus-server\\\"} | logfmt | level=\\\"error\\\" [1m]))\",\"legendFormat\":\"{{env}}/{{pod}}\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0.05],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      message = "${var.product_name} (${var.environment}): Prometheus Errors"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
