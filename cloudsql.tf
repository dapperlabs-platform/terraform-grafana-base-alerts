resource "grafana_rule_group" "rule_group_cloudsql_cpu" {
  count            = var.enable_cloudsql ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): CPU utilization [95/50/5 PERCENTILE] alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): CPU utilization [95/50/5 PERCENTILE] alert"
    condition = "B"

    data {
      ref_id     = "A"
      query_type = "metrics"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.gcp_datasource_uid
      model          = "{\"datasource\":\"${var.gcp_datasource_name}\",\"metricQuery\":{\"aliasBy\":\"REDUCE_PERCENTILE_95\",\"alignmentPeriod\":\"cloud-monitoring-auto\",\"crossSeriesReducer\":\"REDUCE_PERCENTILE_95\",\"filters\":[],\"groupBys\":[\"resource.label.database_id\"],\"metricKind\":\"GAUGE\",\"metricType\":\"cloudsql.googleapis.com/database/cpu/utilization\",\"perSeriesAligner\":\"ALIGN_MEAN\",\"projectName\":\"${var.project_name}\",\"unit\":\"10^2.%\",\"valueType\":\"DOUBLE\"},\"queryType\":\"metrics\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[50],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"avg\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      message = "${var.product_name} (${var.environment}): Database CPU is a little high - take a look."
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}

resource "grafana_rule_group" "rule_group_cloudsql_disk" {
  count            = var.enable_cloudsql ? 1 : 0
  org_id           = var.org_id
  name             = "${var.product_name} (${var.environment}): Total Disk quota, Bytes used alert"
  folder_uid       = var.folder_uid
  interval_seconds = 60

  rule {
    name      = "${var.product_name} (${var.environment}): Total Disk quota, Bytes used alert"
    condition = "B"

    data {
      ref_id     = "A"
      query_type = "metrics"

      relative_time_range {
        from = 300
        to   = 0
      }

      datasource_uid = var.gcp_datasource_uid
      model          = "{\"datasource\":\"${var.gcp_datasource_name}\",\"metricQuery\":{\"aliasBy\":\"{{metric.name}}\",\"alignmentPeriod\":\"cloud-monitoring-auto\",\"crossSeriesReducer\":\"REDUCE_SUM\",\"editorMode\":\"mql\",\"filters\":[],\"groupBys\":[\"resource.label.database_id\"],\"metricKind\":\"GAUGE\",\"metricType\":\"cloudsql.googleapis.com/database/disk/quota\",\"perSeriesAligner\":\"ALIGN_MEAN\",\"preprocessor\":\"none\",\"projectName\":\"${var.project_name}\",\"query\":\"fetch cloudsql_database\\n| metric 'cloudsql.googleapis.com/database/disk/utilization'\\n| group_by 1m, [value_utilization_mean: mean(value.utilization)]\\n| every 1m\\n| group_by [resource.database_id],\\n    [value_utilization_mean_aggregate: aggregate(value_utilization_mean)]\",\"unit\":\"By\",\"valueType\":\"INT64\"},\"queryType\":\"metrics\",\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"type\":\"classic_conditions\",\"refId\":\"B\",\"conditions\":[{\"evaluator\":{\"params\":[90],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"A\"]},\"reducer\":{\"type\":\"max\"}}]}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      message = "${var.product_name} (${var.environment}): CloudSQL disks are filling up. Take a look."
    }
    labels = {
      __contacts__ = var.notification_channel
      service      = var.service_name
    }
    is_paused = false
  }
}
