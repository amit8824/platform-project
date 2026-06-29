#!/bin/bash

set -e

# Determine the project root based on the script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "==============================="
echo "Platform Project Safe Destroy"
echo "==============================="

echo ""
echo "Step 1 - Current Kubernetes Context"
kubectl config current-context || true

echo ""
echo "Step 2 - Existing ArgoCD Applications"
kubectl get applications -A || true

echo ""
echo "Step 3 - Existing Helm Releases"
helm list --all-namespaces || true

echo ""
echo "Step 4 - Waiting 5 seconds..."
sleep 5

echo ""
echo "Step 5 - Running Terraform Destroy"

cd "$PROJECT_ROOT/terraform/env/dev"

echo ""
echo "Current Directory:"
pwd

terraform destroy -auto-approve

echo ""
echo "=========================================="
echo " Terraform Destroy Completed"
echo "=========================================="

echo ""
echo "Checking Remaining AWS Resources..."

echo ""
echo "EKS Clusters"
aws eks list-clusters --region ap-south-1

echo ""
echo "EC2 Instances"
aws ec2 describe-instances \
--region ap-south-1 \
--filters Name=instance-state-name,Values=running \
--query 'Reservations[*].Instances[*].[InstanceId,State.Name]' \
--output table

echo ""
echo "NAT Gateways"
aws ec2 describe-nat-gateways \
--region ap-south-1 \
--query 'NatGateways[*].[NatGatewayId,State]' \
--output table

echo ""
echo "Load Balancers"
aws elbv2 describe-load-balancers \
--region ap-south-1 \
--query 'LoadBalancers[*].[LoadBalancerName,State.Code]' \
--output table

echo ""
echo "EBS Volumes"
aws ec2 describe-volumes \
--region ap-south-1 \
--query 'Volumes[*].[VolumeId,State]' \
--output table

echo ""
echo "Elastic IPs"
aws ec2 describe-addresses \
--region ap-south-1 \
--query 'Addresses[*].[PublicIp,AllocationId]' \
--output table

echo ""
echo "ECR Repositories"
aws ecr describe-repositories \
--region ap-south-1 \
--query 'repositories[*].repositoryName' \
--output table

echo ""
echo "=========================================="
echo "Destroy Validation Finished"
echo "=========================================="