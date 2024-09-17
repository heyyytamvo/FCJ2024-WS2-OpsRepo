#!/bin/bash
#set up argo cd
kubectl apply -f argocd/namespace.yaml
kubectl apply -f argocd/default.yaml -n argocd

#set up efk stack
kubectl apply -f EFK/.

#set up Prometheus and Grafana
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-operator prometheus-community/kube-prometheus-stack -n monitoring
kubectl apply -f monitoring/grafana.yaml -n monitoring
# curl http://prometheus-operator-kube-p-prometheus.monitoring.svc.cluster.local:9090