ARG BUILD_IMAGE=ubuntu:jammy-20211122
ARG RUN_IMAGE=ubuntu:jammy-20211122
# ARG IMGPKG_VERSION=0.26.0
# ARG IMGPKG_SHA256=a16baeb24ffd3a598c99d606f084193bd13fa6b2876e7a83ec585943c956fadc
ARG KBLD_VERSION=0.32.0
ARG KBLD_SHA256=de546ac46599e981c20ad74cd2deedf2b0f52458885d00b46b759eddb917351a
ARG KUBECTL_VERSION=1.23.4
ARG KUBECTL_SHA256=3f0398d4c8a5ff633e09abd0764ed3b9091fafbe3044970108794b02731c72d6
ARG PIVNET_CLI_VERSION=3.0.1
ARG PIVNET_CLI_SHA256=7ade3877a7e973227c58cac6ae3a51ad788130387c166463691fe08f377928fc
ARG CLUSTER_ESSENTIALS_VERSION=1.0.0
ARG CLUSTER_ESSENTIALS_FILEID=1105818
ARG CLUSTER_ESSENTIALS_SHA256=24613086760d5566f33e94307c0de5871c70d65f5ecf3b73afd522b7fd0dd1de
ARG CLUSTER_ESSENTIALS_BUNDLE_SHA256=82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343
ARG TANZUNET_USERNAME=
ARG TANZUNET_PASSWORD=
ARG PIVNET_TOKEN=

# Phase 0 - Fetch and install CLI and imgpkg files for kapp-controller
FROM $BUILD_IMAGE AS build
# ARG IMGPKG_VERSION
# ARG IMGPKG_SHA256
ARG KBLD_VERSION
ARG KBLD_SHA256
ARG KUBECTL_VERSION
ARG KUBECTL_SHA256
ARG PIVNET_CLI_VERSION
ARG PIVNET_CLI_SHA256
ARG CLUSTER_ESSENTIALS_VERSION
ARG CLUSTER_ESSENTIALS_FILEID
ARG CLUSTER_ESSENTIALS_SHA256
ARG CLUSTER_ESSENTIALS_BUNDLE_SHA256
ARG TANZUNET_USERNAME
ARG TANZUNET_PASSWORD
ARG PIVNET_TOKEN

ENV PIVNET_TOKEN $PIVNET_TOKEN

RUN apt-get update && \
  apt-get install -y --no-install-recommends ca-certificates curl && \
  apt-get clean

# Download and verify before continuing
# For KUBECTL find stable version here: https://dl.k8s.io/release/stable.txt 
#   and its SHA here: https://dl.k8s.io/v1.23.4/bin/linux/amd64/kubectl.sha256
RUN mkdir -p tmp && \
  # curl -L "https://github.com/vmware-tanzu/carvel-imgpkg/releases/download/v${IMGPKG_VERSION}/imgpkg-linux-amd64" -o ./tmp/imgpkg && \
  # echo "${IMGPKG_SHA256} ./tmp/imgpkg" > packages.txt && \
  curl -L "https://github.com/vmware-tanzu/carvel-kbld/releases/download/v${KBLD_VERSION}/kbld-linux-amd64" -o ./tmp/kbld && \
  echo "${KBLD_SHA256} ./tmp/kbld" > packages.txt && \
  curl -L "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o ./tmp/kubectl && \
  echo "${KUBECTL_SHA256} ./tmp/kubectl" >> packages.txt && \
  curl -L "https://github.com/pivotal-cf/pivnet-cli/releases/download/v${PIVNET_CLI_VERSION}/pivnet-linux-amd64-${PIVNET_CLI_VERSION}" -o ./tmp/pivnet && \
  echo "${PIVNET_CLI_SHA256} ./tmp/pivnet" >> packages.txt && \
  sha256sum --strict -c packages.txt

# Install tools in the path
RUN \
  # cp ./tmp/imgpkg /usr/local/bin/imgpkg && \
  cp ./tmp/kbld /usr/local/bin/kbld && \
  cp ./tmp/kubectl /usr/local/bin/kubectl && \
  cp ./tmp/pivnet /usr/local/bin/pivnet && \
  # chmod +x /usr/local/bin/imgpkg && \
  chmod +x /usr/local/bin/kbld && \
  chmod +x /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/pivnet

# Now fetch TANZU net artifacts and verify (we need the pivnet cli for this)
RUN \
  pivnet login --api-token="$PIVNET_TOKEN" && \
  pivnet download-product-files --product-slug='tanzu-cluster-essentials' \
    --release-version="${CLUSTER_ESSENTIALS_VERSION}" \
    --product-file-id="${CLUSTER_ESSENTIALS_FILEID}" \
  -d ./tmp && \
  mv ./tmp/tanzu-cluster-essentials-linux-amd64-${CLUSTER_ESSENTIALS_VERSION}.tgz ./tmp/essentials.tgz && \
  echo "${CLUSTER_ESSENTIALS_SHA256} ./tmp/essentials.tgz" > tanzunet.txt && \
  sha256sum --strict -c tanzunet.txt

# Unpack cluster essentials and use it to fetch the required packages

# Now use imgpkg to fetch the desired package of kapp-controller
RUN \
  tar -xvf ./tmp/essentials.tgz -C ./tmp/tanzu-cluster-essentials && \
  cp ./tmp/tanzu-cluster-essentials/kapp /usr/local/bin/kapp && \
  cp ./tmp/tanzu-cluster-essentials/imgpkg /usr/local/bin/imgpkg && \
  chmod +x /usr/local/bin/imgpkg && \
  chmod +x /usr/local/bin/kapp && \
  export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:${CLUSTER_ESSENTIALS_BUNDLE_SHA256} && \
  export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com && \
  export INSTALL_REGISTRY_USERNAME=${TANZUNET_USERNAME} && \
  export INSTALL_REGISTRY_PASSWORD=${TANZUNET_PASSWORD} && \
  cd ./tmp/tanzu-cluster-essentials && \
  ls -l && \
  # TODO do equivalent of install.sh BUT ONLY TO DOWNLOAD PACKAGES NOT TO INSTALL THEM
  #./install.sh 
  echo "DO SOMETHING"

FROM $RUN_IMAGE as run
# Copy over relevant TAR paths and CLI from the base image
COPY --from=build /usr/local/bin/imgpkg /usr/local/bin/imgpkg
COPY --from=build /usr/local/bin/kbld /usr/local/bin/kbld
COPY --from=build /usr/local/bin/kubectl /usr/local/bin/kubectl

# Copy external install script
COPY Dockerfiles/kappbootstrap/install-offline.sh .

# TODO The following script needs completing!
CMD ["sh", "-c", "install-offline.sh"]
