# Args
ARG BASE_IMAGE=ubuntu:jammy-20211122
# OR myorg/myapp:latest if overriding via ARGs in Docker build

# Phase 0 - Add python to Ubuntu base image
FROM $BASE_IMAGE AS compile-image
RUN apt-get update && \
  apt-get install -y --no-install-recommends python3 python3-pip python3.9-venv && \
  apt-get clean
