#!/bin/bash

echo "========================================="
echo "Starting Platform Port Forwards"
echo "========================================="

# Kill old port-forwards
pkill -f "kubectl port-forward" 2>/dev/null || true

sleep 2

echo "Starting the Application..."
kubectl port-forward svc/platform-service 8000:80 >/tmp/argocd.log 2>&1 &

echo "Starting ArgoCD..."
kubectl port-forward svc/argocd-server -n argocd 8081:443 >/tmp/argocd.log 2>&1 &

echo "Starting Grafana..."
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80 >/tmp/grafana.log 2>&1 &

echo "Starting Prometheus..."
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090 >/tmp/prometheus.log 2>&1 &


echo "Waiting..."
sleep 5

echo ""
echo "================ URLs ================"
echo "App Health" : http://localhost:8000/health
echo "App Metrics": http://localhost:8000/metrics
echo "ArgoCD      : https://localhost:8081"
echo "Grafana     : http://localhost:3000"
echo "Prometheus  : http://localhost:9090"
echo "======================================"