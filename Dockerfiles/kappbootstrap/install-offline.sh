#!/bin/bash

set -e -o pipefail

# DO NOT MANUALLY EDIT THIS FILE!!!

ns_name=tanzu-cluster-essentials
echo "## Creating namespace $ns_name"
kubectl create ns $ns_name 2>/dev/null || true

export YTT_registry__server=$INSTALL_REGISTRY_HOSTNAME
export YTT_registry__username=$INSTALL_REGISTRY_USERNAME
export YTT_registry__password=$INSTALL_REGISTRY_PASSWORD

echo "## Deploying kapp-controller"
ytt -f ./bundle/kapp-controller/config/ -f ./bundle/registry-creds/ --data-values-env YTT --data-value-yaml kappController.deployment.concurrency=10 \
	| kbld -f- -f ./bundle/.imgpkg/images.yml \
	| kapp deploy -a kapp-controller -n $ns_name -f- --yes

echo "## Deploying secretgen-controller"
ytt -f ./bundle/secretgen-controller/config/ -f ./bundle/registry-creds/ --data-values-env YTT \
	| kbld -f- -f ./bundle/.imgpkg/images.yml \
	| kapp deploy -a secretgen-controller -n $ns_name -f- --yes
