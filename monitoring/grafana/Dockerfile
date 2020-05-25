FROM grafana/grafana:5.0.0
COPY prometheus.yml /etc/grafana/provisioning/datasources/
COPY prometheus_dashboards.yml /etc/grafana/provisioning/dashboards/
COPY *.json /var/lib/grafana/dashboards/
