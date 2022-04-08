#!/bin/bash

set -e -o pipefail

# DO NOT MANUALLY EDIT THIS FILE!!!

ns_name=tanzu-cluster-essentials
echo "## Creating namespace $ns_name"
kubectl create ns $ns_name 2>/dev/null || true

echo "Using target registry hostname: $INSTALL_REGISTRY_HOSTNAME"

[ -z "$INSTALL_REGISTRY_HOSTNAME" ] && { echo "INSTALL_REGISTRY_HOSTNAME env var must not be empty"; exit 1; }
[ -z "$INSTALL_REGISTRY_USERNAME" ] && { echo "INSTALL_REGISTRY_USERNAME env var must not be empty"; exit 1; }
[ -z "$INSTALL_REGISTRY_PASSWORD" ] && { echo "INSTALL_REGISTRY_PASSWORD env var must not be empty"; exit 1; }

export IMGPKG_REGISTRY_HOSTNAME_0=$INSTALL_REGISTRY_HOSTNAME
export IMGPKG_REGISTRY_USERNAME_0=$INSTALL_REGISTRY_USERNAME
export IMGPKG_REGISTRY_PASSWORD_0=$INSTALL_REGISTRY_PASSWORD
imgpkg --debug copy --tar ./cebundle.tar --to-repo $INSTALL_REGISTRY_HOSTNAME/tanzu-cluster-essentials/cluster-essentials-bundle

# TODO rewrite images.yml here with location of the new server (if needed?)

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
