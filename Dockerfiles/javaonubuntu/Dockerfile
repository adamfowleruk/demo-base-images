# Args
ARG BASE_IMAGE=ubuntu:jammy-20211122
# OR myorg/myapp:latest if overriding via ARGs in Docker build
ARG OPENJDK_PACKAGE=openjdk-11-jdk-headless
# OR openjdk-11-jre-headless OR openjdk-18-jdk-headless via ARGs in Docker build
ARG JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Phase 0 - Add Java to Ubuntu base image
FROM $BASE_IMAGE AS compile-image
ARG OPENJDK_PACKAGE
ARG JAVA_HOME
RUN apt-get update && \
  apt-get install -y --no-install-recommends ${OPENJDK_PACKAGE} && \
  apt-get clean
ENV JAVA_HOME $JAVA_HOME
