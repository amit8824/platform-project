#!/bin/bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TF_DIR="$PROJECT_ROOT/terraform/env/dev"

echo "========================================="
echo " Destroying Platform Project"
echo "========================================="

###############################################
# Update kubeconfig (ignore if cluster already gone)
###############################################

aws eks update-kubeconfig \
  --region ap-south-1 \
  --name platform-eks >/dev/null 2>&1 || true

###############################################
# Delete ArgoCD Application
###############################################

echo "Deleting ArgoCD Application..."

kubectl delete application platform-api \
  -n argocd \
  --ignore-not-found=true || true

sleep 10

###############################################
# Remove Application from Terraform state
###############################################

cd "$TF_DIR"

terraform state rm \
module.argocd_application.kubernetes_manifest.platform_application \
>/dev/null 2>&1 || true

###############################################
# Destroy Terraform
###############################################

echo
echo "Running Terraform Destroy..."

terraform destroy -auto-approve

###############################################
# Cluster already destroyed?
###############################################

if ! kubectl cluster-info >/dev/null 2>&1
then
    echo
    echo "EKS cluster deleted successfully."
    exit 0
fi

###############################################
# Cleanup stuck namespaces
###############################################

for ns in argocd monitoring argo-rollouts
do

    if kubectl get ns "$ns" >/dev/null 2>&1
    then

        STATUS=$(kubectl get ns "$ns" \
        -o jsonpath='{.status.phase}')

        if [[ "$STATUS" == "Terminating" ]]
        then

            echo "Removing finalizers from $ns..."

            kubectl get namespace "$ns" -o json \
            | jq '.spec.finalizers=[]' \
            | kubectl replace \
            --raw "/api/v1/namespaces/$ns/finalize" \
            -f - || true

        fi

    fi

done

echo
echo "========================================="
echo " Destroy Completed"
echo "========================================="