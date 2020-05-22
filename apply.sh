#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

# Apply cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.0/cert-manager.yaml
kubectl -n cert-manager wait --for=condition=Ready pod --all

# Apply nginx-ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml

# Apply kuard, nginx-ingress config map, and lets encrypt issuer
kustomize build | kubectl apply -f -
# Equivalent to:
# kubectl apply -f nginx_config_map.yaml
# kubectl apply -f lets_encrypt.yaml
# kubectl apply -f kuard.yaml
