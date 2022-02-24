# Args
ARG BASE_IMAGE=ubuntu:jammy-20211122
# OR myorg/myapp:latest if overriding via ARGs in Docker build
ARG OPENJDK_PACKAGE=openjdk-11
# OR openjdk-11-jre OR openjdk-18 via ARGs in Docker build

# Phase 0 - Add Java to Ubuntu base image
FROM $BASE_IMAGE AS compile-image
ARG OPENJDK_PACKAGE
RUN apt-get update && \
  apt-get install -y --no-install-recommends ${OPENJDK_PACKAGE} && \
  apt-get clean
