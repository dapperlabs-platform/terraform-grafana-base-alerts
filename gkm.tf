resource "grafana_rule_group" "rule_group_gkm" {
  count            = var.enable_gkm_alerts ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): SRE K8s Eval Group"
  folder_uid       = var.folder_uid
  interval_seconds = 120

  rule {
    name      = "${var.product_name} (${var.environment}): Alloy-Metrics status"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = <<EOF
{
  "adhocFilters": [],
  "datasource": {
    "type": "prometheus",
    "uid": "${var.prom_datasource_uid}"
  },
  "editorMode": "code",
  "expr": "count(alloy_build_info{pod='grafana-k8s-monitoring-alloy-metrics-0',env='${var.environment}'})",
  "instant": false,
  "interval": "",
  "intervalMs": 60000,
  "legendFormat": "__auto",
  "maxDataPoints": 43200,
  "range": true,
  "refId": "A"
}
EOF
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = <<EOF
{
  "conditions": [
    {
      "evaluator": {
        "params": [],
        "type": "gt"
      },
      "operator": {
        "type": "and"
      },
      "query": {
        "params": ["B"]
      },
      "reducer": {
        "params": [],
        "type": "last"
      },
      "type": "query"
    }
  ],
  "datasource": {
    "type": "__expr__",
    "uid": "__expr__"
  },
  "expression": "A",
  "intervalMs": 1000,
  "maxDataPoints": 43200,
  "reducer": "last",
  "refId": "B",
  "type": "reduce"
}
EOF
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = <<EOF
{
  "conditions": [
    {
      "evaluator": {
        "params": [1, 1],
        "type": "ne"
      },
      "operator": {
        "type": "and"
      },
      "query": {
        "params": ["C"]
      },
      "reducer": {
        "params": [],
        "type": "last"
      },
      "type": "query"
    }
  ],
  "datasource": {
    "type": "__expr__",
    "uid": "__expr__"
  },
  "expression": "B",
  "intervalMs": 1000,
  "maxDataPoints": 43200,
  "refId": "C",
  "type": "threshold"
}
EOF
    }

    no_data_state  = "Alerting"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): Alloy-Metrics status check failed"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
  rule {
    name      = "${var.product_name} (${var.environment}): SRE Pods in CrashLoopBackOff"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = <<EOF
{
  "adhocFilters": [],
  "datasource": {
    "type": "prometheus",
    "uid": "${var.prom_datasource_uid}"
  },
  "editorMode": "code",
  "expr": "kube_pod_container_status_waiting_reason{namespace='sre',reason='CrashLoopBackOff',env='${var.environment}'}",
  "instant": true,
  "interval": "",
  "intervalMs": 60000,
  "legendFormat": "__auto",
  "maxDataPoints": 43200,
  "range": false,
  "refId": "A"
}
EOF
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = <<EOF
{
  "conditions": [
    {
      "evaluator": {
        "params": [0],
        "type": "gt"
      },
      "operator": {
        "type": "and"
      },
      "query": {
        "params": ["C"]
      },
      "reducer": {
        "params": [],
        "type": "last"
      },
      "type": "query"
    }
  ],
  "datasource": {
    "type": "__expr__",
    "uid": "__expr__"
  },
  "expression": "A",
  "intervalMs": 1000,
  "maxDataPoints": 43200,
  "refId": "C",
  "type": "threshold"
}
EOF
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): SRE pods are in CrashLoopBackOff state"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
  rule {
    name      = "${var.product_name} (${var.environment}): Cluster CPU"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 21600
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = <<EOF
{
  "adhocFilters": [],
  "datasource": {
    "type": "prometheus",
    "uid": "${var.prom_datasource_uid}"
  },
  "editorMode": "code",
  "expr": "sum by (cluster) (sum by (cluster, instance) (max by (cluster, instance, cpu, core) (1 - rate(node_cpu_seconds_total{env='${var.environment}', mode=~'idle'}[$__rate_interval]) >= 0)) or sum by (cluster, instance) (rate(node_cpu_usage_seconds_total{env='${var.environment}'}[$__rate_interval])))\n      / on (cluster)\n      sum by (cluster) (max by (cluster, node) (max by (cluster, node, resource) (kube_node_status_capacity{env='${var.environment}', resource=~'cpu'})))\n    ",
  "instant": true,
  "interval": "",
  "intervalMs": 60000,
  "legendFormat": "__auto",
  "maxDataPoints": 43200,
  "range": false,
  "refId": "A"
}
EOF
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = <<EOF
{
  "conditions": [
    {
      "evaluator": {
        "params": [0.8],
        "type": "gt"
      },
      "operator": {
        "type": "and"
      },
      "query": {
        "params": ["C"]
      },
      "reducer": {
        "params": [],
        "type": "last"
      },
      "type": "query"
    }
  ],
  "datasource": {
    "type": "__expr__",
    "uid": "__expr__"
  },
  "expression": "A",
  "intervalMs": 1000,
  "maxDataPoints": 43200,
  "refId": "C",
  "type": "threshold"
}
EOF
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High cluster CPU usage detected"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
  rule {
    name      = "${var.product_name} (${var.environment}): Cluster Memory"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 21600
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = <<EOF
{
  "adhocFilters": [],
  "datasource": {
    "type": "prometheus",
    "uid": "${var.prom_datasource_uid}"
  },
  "editorMode": "code",
  "expr": "1 - (\n sum by (cluster) (max by (cluster, node) (label_replace(windows_memory_available_bytes{env='${var.environment}'} or node_memory_MemAvailable_bytes{env='${var.environment}'}, 'node', '$1', 'instance', '(.+)')))\n / on (cluster)\n sum by (cluster) (max by (cluster, node) (max by (cluster, node, resource) (kube_node_status_capacity{env='${var.environment}', resource=~'memory'})))\n      )\n    ",
  "instant": true,
  "interval": "",
  "intervalMs": 60000,
  "legendFormat": "__auto",
  "maxDataPoints": 43200,
  "range": false,
  "refId": "A"
}
EOF
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = <<EOF
{
  "conditions": [
    {
      "evaluator": {
        "params": [0.8],
        "type": "gt"
      },
      "operator": {
        "type": "and"
      },
      "query": {
        "params": ["C"]
      },
      "reducer": {
        "params": [],
        "type": "last"
      },
      "type": "query"
    }
  ],
  "datasource": {
    "type": "__expr__",
    "uid": "__expr__"
  },
  "expression": "A",
  "intervalMs": 1000,
  "maxDataPoints": 43200,
  "refId": "C",
  "type": "threshold"
}
EOF
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High cluster memory usage detected"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
  rule {
    name      = "${var.product_name} (${var.environment}): SRE Pods at 80% CPU Limit"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 21600
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = <<EOF
{
  "adhocFilters": [],
  "datasource": {
    "type": "prometheus",
    "uid": "${var.prom_datasource_uid}"
  },
  "editorMode": "code",
  "expr": "sum by(pod) (rate(container_cpu_usage_seconds_total{namespace='sre',env='${var.environment}'}[$__rate_interval])) / sum by(pod)(kube_pod_container_resource_limits{resource='cpu',env='${var.environment}',namespace='sre'})",
  "instant": true,
  "interval": "",
  "intervalMs": 60000,
  "legendFormat": "__auto",
  "maxDataPoints": 43200,
  "range": false,
  "refId": "A"
}
EOF
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = <<EOF
{
  "conditions": [
    {
      "evaluator": {
        "params": [0.8],
        "type": "gt"
      },
      "operator": {
        "type": "and"
      },
      "query": {
        "params": ["C"]
      },
      "reducer": {
        "params": [],
        "type": "last"
      },
      "type": "query"
    }
  ],
  "datasource": {
    "type": "__expr__",
    "uid": "__expr__"
  },
  "expression": "A",
  "intervalMs": 1000,
  "maxDataPoints": 43200,
  "refId": "C",
  "type": "threshold"
}
EOF
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High CPU usage in SRE pods"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
  rule {
    name      = "${var.product_name} (${var.environment}): SRE Pods at 80% Memory Limit"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 21600
        to   = 0
      }

      datasource_uid = var.prom_datasource_uid
      model          = <<EOF
{
  "adhocFilters": [],
  "datasource": {
    "type": "prometheus",
    "uid": "${var.prom_datasource_uid}"
  },
  "editorMode": "code",
  "expr": "sum by(pod) (max by (cluster, node, namespace, pod, container, image) (node_namespace_pod_container:container_memory_working_set_bytes{namespace='sre',env='${var.environment}'})) / sum by(pod)(kube_pod_container_resource_limits{resource='memory',env='${var.environment}',namespace='sre'})",
  "instant": true,
  "interval": "",
  "intervalMs": 60000,
  "legendFormat": "__auto",
  "maxDataPoints": 43200,
  "range": false,
  "refId": "A"
}
EOF
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = <<EOF
{
  "conditions": [
    {
      "evaluator": {
        "params": [0.8],
        "type": "gt"
      },
      "operator": {
        "type": "and"
      },
      "query": {
        "params": ["C"]
      },
      "reducer": {
        "params": [],
        "type": "last"
      },
      "type": "query"
    }
  ],
  "datasource": {
    "type": "__expr__",
    "uid": "__expr__"
  },
  "expression": "A",
  "intervalMs": 1000,
  "maxDataPoints": 43200,
  "refId": "C",
  "type": "threshold"
}
EOF
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): High memory usage in SRE pods"
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
