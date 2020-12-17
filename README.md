# external-svc-monitor
Deploy ServiceMonitor, Service and Endpoints for Prometheus to scrape data outside cluster.
Currently supports EKS only.
Example usage:
```
name: monitoring
on:
  push:
    branches:
      - main
jobs:
  test:
    name: "Test"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Apply
        uses: kamilswiec/external-svc-monitor@v0.1.1
        with:
          aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          kubeconfig: ${{ secrets.KUBECONFIG }}
          name: test
          namespace: test
          labels: |
            release: prometheus-prom-stack
            test: test
          ip_address: 1.1.1.1
          metrics_port: cadvisor:9010
          endpoints_config: |
            - port: cadvisor
              metricRelabelings:
                - sourceLabels: ['container_label_com_name']
                  targetLabel: 'name'
```
To delete created resources add input `action: delete`.
Remember about `release` label if deployed prometheus operator with [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus).
