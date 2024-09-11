kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-operator prometheus-community/kube-prometheus-stack -n monitoring
curl http://prometheus-operator-kube-p-prometheus.monitoring.svc.cluster.local:9090