#!/bin/bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TF_DIR="$PROJECT_ROOT/terraform/env/dev"

AWS_REGION="ap-south-1"
CLUSTER_NAME="platform-eks"

cd "$TF_DIR"

echo "========================================="
echo " Phase 1 - Create AWS Infrastructure"
echo "========================================="

terraform init

terraform apply \
-target=module.vpc \
-target=module.eks \
-auto-approve

echo
echo "Waiting for EKS API..."

until aws eks describe-cluster \
--name "$CLUSTER_NAME" \
--region "$AWS_REGION" >/dev/null 2>&1
do
    echo "Waiting for cluster..."
    sleep 20
done

echo
echo "Updating kubeconfig..."

aws eks update-kubeconfig \
--region "$AWS_REGION" \
--name "$CLUSTER_NAME"

echo
echo "Waiting for nodes..."

kubectl wait \
--for=condition=Ready node \
--all \
--timeout=10m

echo
echo "========================================="
echo " Phase 2 - Install Addons"
echo "========================================="

terraform apply -auto-approve

echo
echo "========================================="
echo " Platform Ready"
echo "========================================="