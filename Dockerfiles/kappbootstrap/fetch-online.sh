#!/bin/bash

set -e -o pipefail

# DO NOT MANUALLY EDIT THIS FILE!!!

# Note script should be idempotent

echo "## Pulling bundle from $INSTALL_REGISTRY_HOSTNAME (username: $INSTALL_REGISTRY_USERNAME)"

[ -z "$INSTALL_BUNDLE" ]            && { echo "INSTALL_BUNDLE env var must not be empty"; exit 1; }
[ -z "$INSTALL_REGISTRY_HOSTNAME" ] && { echo "INSTALL_REGISTRY_HOSTNAME env var must not be empty"; exit 1; }
[ -z "$INSTALL_REGISTRY_USERNAME" ] && { echo "INSTALL_REGISTRY_USERNAME env var must not be empty"; exit 1; }
[ -z "$INSTALL_REGISTRY_PASSWORD" ] && { echo "INSTALL_REGISTRY_PASSWORD env var must not be empty"; exit 1; }

export IMGPKG_REGISTRY_HOSTNAME_0=$INSTALL_REGISTRY_HOSTNAME
export IMGPKG_REGISTRY_USERNAME_0=$INSTALL_REGISTRY_USERNAME
export IMGPKG_REGISTRY_PASSWORD_0=$INSTALL_REGISTRY_PASSWORD
imgpkg pull -b $INSTALL_BUNDLE -o ./bundle/
imgpkg copy --lock ./bundle/.imgpkg/images.yml --to-tar cebundle.tar