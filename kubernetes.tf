resource "grafana_rule_group" "rule_group_cluster_cpu_usage" {
  count            = var.enable_kubernetes_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Cluster CPU usage (1m avg) alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Cluster CPU usage (1m avg) alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"sum (rate (container_cpu_usage_seconds_total{id=\\\"/\\\",env=\\\"${var.environment}\\\"}[1m])) / sum (machine_cpu_cores{env=\\\"${var.environment}\\\"}) * 100\",\"interval\":\"10s\",\"intervalFactor\":1,\"legendFormat\":\"\",\"refId\":\"A\",\"step\":10}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[60],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): Cluster CPU > threshold"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_cluster_filesystem" {
  count            = var.enable_kubernetes_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Cluster filesystem usage alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Cluster filesystem usage alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"expr\":\"sum (container_fs_usage_bytes{device=~\\\"^/dev/[sv]d[a-z][1-9]$\\\",id=\\\"/\\\",env=\\\"${var.environment}\\\"}) / sum (container_fs_limit_bytes{device=~\\\"^/dev/[sv]d[a-z][1-9]$\\\",id=\\\"/\\\",env=\\\"${var.environment}\\\"}) * 100\",\"interval\":\"10s\",\"intervalFactor\":1,\"legendFormat\":\"\",\"metric\":\"\",\"refId\":\"A\",\"step\":10}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[85],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High cluster filesystem usage"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_cluster_memory" {
  count            = var.enable_kubernetes_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Cluster memory usage alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Cluster memory usage alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"expr\":\"sum (container_memory_working_set_bytes{id=\\\"/\\\",env=\\\"${var.environment}\\\"}) / sum (machine_memory_bytes{env=\\\"${var.environment}\\\"}) * 100\",\"interval\":\"10s\",\"intervalFactor\":1,\"refId\":\"A\",\"step\":10}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[65],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High Cluster Memory"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_container_cpu_usage" {
  count            = var.enable_kubernetes_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Containers CPU usage (1m avg) alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Containers CPU usage (1m avg) alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"topk(10, sum by(pod, container) (rate(container_cpu_usage_seconds_total{env=\\\"${var.environment}\\\", pod!~\\\"(promtail).*\\\"}[5m]))\\n/\\nsum by(pod, container)(kube_pod_container_resource_limits{resource=\\\"cpu\\\",env=\\\"${var.environment}\\\"}))\",\"interval\":\"10s\",\"intervalFactor\":1,\"legendFormat\":\"pod: {{ pod }} | {{ container }}\",\"metric\":\"container_cpu\",\"refId\":\"A\",\"step\":10}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0.8],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High CPU Usage - Containers"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_container_memory_usage" {
  count            = var.enable_kubernetes_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Containers Memory usage alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Containers Memory usage alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"topk(10, sum by(pod, container) (rate(container_memory_usage_bytes{env=\\\"${var.environment}\\\"}[5m]))\\n/\\nsum by(pod, container)(kube_pod_container_resource_limits{resource=\\\"memory\\\",env=\\\"${var.environment}\\\"}))\",\"interval\":\"10s\",\"intervalFactor\":1,\"legendFormat\":\"pod: {{ pod }} | {{ container }}\",\"metric\":\"container_cpu\",\"refId\":\"A\",\"step\":10}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0.8],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High Memory Usage - Containers"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_oom_container_restarts" {
  count            = var.enable_kubernetes_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): OOM container restarts alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): OOM container restarts alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"datasource\":\"${var.product_name} Prometheus\",\"exemplar\":true,\"expr\":\"sum by(container) (increase(kube_pod_container_status_restarts_total{namespace=\\\"sre\\\", pod!~\\\".*github-actions-runner.*\\\", env=\\\"${var.environment}\\\"} [1m]))\\nand on(container)\\ncount by(container) (kube_pod_container_status_last_terminated_reason{namespace=\\\"sre\\\", pod!~\\\".*github-actions-runner.*\\\", env=\\\"${var.environment}\\\", reason=\\\"OOMKilled\\\"})\",\"interval\":\"\",\"legendFormat\":\"{{container}}\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[2],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"max\"}}]}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      message = "OOM Container Restarts"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
      severity     = "warning"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_pod_cpu_usage" {
  count            = var.enable_kubernetes_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Pods CPU usage (1m avg) alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Pods CPU usage (1m avg) alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"topk(10, sum by(pod) (rate(container_cpu_usage_seconds_total{container!=\\\"\\\",env=\\\"${var.environment}\\\"}[5m]))\\n/\\nsum by(pod)(kube_pod_container_resource_limits{resource=\\\"cpu\\\",env=\\\"${var.environment}\\\"}))\",\"interval\":\"10s\",\"intervalFactor\":1,\"legendFormat\":\"{{ pod }}\",\"metric\":\"container_cpu\",\"refId\":\"A\",\"step\":10}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0.8],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High CPU Usage - Pods"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_pod_memory_usage" {
  count            = var.enable_kubernetes_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Pods Memory usage alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Pods Memory usage alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"exemplar\":true,\"expr\":\"topk(10, sum by(pod) (rate(container_memory_usage_bytes{env=\\\"${var.environment}\\\"}[5m]))\\n/\\nsum by(pod)(kube_pod_container_resource_limits{resource=\\\"memory\\\",env=\\\"${var.environment}\\\"}))\",\"interval\":\"10s\",\"intervalFactor\":1,\"legendFormat\":\"{{ pod }}\",\"metric\":\"container_cpu\",\"refId\":\"A\",\"step\":10}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[0.8],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"min\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High Memory Usage - Pods"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_pod_terminated" {
  count            = var.enable_kubernetes_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Pods Terminated alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Pods Terminated alert"
    condition = "B"

    data {
      ref_id = "A"

      relative_time_range {
        from = 120
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = "{\"datasource\":\"${var.product_name} Prometheus\",\"exemplar\":true,\"expr\":\"sum by(env,namespace,container,reason) (kube_pod_container_status_terminated_reason{namespace=\\\"sre\\\", pod!~\\\".*github-actions-runner.*\\\", env=\\\"${var.environment}\\\", reason!=\\\"Completed\\\"} \\u003e 0)\",\"interval\":\"\",\"legendFormat\":\"{{env}}/{{namespace}}/{{container}} - {{reason}}\",\"refId\":\"A\"}"
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

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "8m"
    annotations = {
      message = "${var.product_name} (${var.environment}): Some pods were terminated - wonder why?"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
      severity     = "warning"
    }
    is_paused = false
  }
}
