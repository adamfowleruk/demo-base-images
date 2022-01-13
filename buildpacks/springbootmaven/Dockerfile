# Args
## Buildtime and Image definition args
# ARG BUILDER_BASE_IMAGE=openjdk:8u312-jdk-slim-bullseye
ARG BUILDER_BASE_IMAGE=openjdk:11.0.13-jdk-slim-bullseye
# ARG RUNNER_BASE_IMAGE=openjdk:8u312-jre-slim-bullseye
ARG RUNNER_BASE_IMAGE=openjdk:11.0.13-jdk-slim-bullseye
ARG APP_FOLDER=.
ARG APP_JAR_FILENAME=target/*.jar
ARG RUN_MAIN_CLASS=io.pivotal.pa.rabbitmq.adsbliveprocessor.ADSBLiveProcessorApplication

ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"

# Create a Maven Java Spring Boot builder image
FROM $BUILDER_BASE_IMAGE as builder
## Import global ARG values
ARG APP_FOLDER
ARG APP_JAR_FILENAME
ARG MAVEN_VERSION
ARG USER_HOME_DIR



RUN apt-get update && \
  apt-get install -y --no-install-recommends curl tar bash && \
  apt-get clean
# RUN apk add --no-cache curl tar bash
RUN mkdir -p /usr/share/maven && \
  curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
  ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
# TODO Add SHA256 hash verification to this known maven binary image download
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
# speed up Maven JVM a bit
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"


# TODO move the above into a separate springbaseapt docker image
# TODO Use just the below as the buildpack image, using the springbaseapt image by default
# TODO externalise SPRING jar files into their own layer (maven repo above)
#      so they are not overridden by the app itself going out to the internet
#      i.e. have an 'Organisation parent pom' for this type of project

# Stage 1 - Build the spring boot app
WORKDIR /spring-app

COPY ${APP_FOLDER} .

# WARNING: Assumes POM auto calls "spring-boot:repackage" itself
# NOTE leaving ls -la in to ensure the app is unpackaged correctly
RUN ls -la && \
  mvn clean package && \
  mkdir -p target/dependency && \
  (cd target/dependency; jar -xf ../*.jar) 
  
  # && \
  # ls -Rla target/dependency && ls -la target
#cp -R target/classes target/dependency/BOOT-INF/classes && \

# Useful debugging tools to include in the above:-
# export && pwd && ls -l && ls -l * && \
#  ls -l && ls -l * && \
# The above leaves the source code in place... larger container image size
# So next we use a second stage to eliminate those temporary files


# Stage 2 - runtime
FROM $RUNNER_BASE_IMAGE
ARG RUN_MAIN_CLASS
# TODO extract RUN_MAIN_CLASS from META-INF/MANIFEST.MF file's 
#      Start-Class: <MAIN_CLASS> entry

# Old way - 'far' spring JAR file:-
# COPY --from=builder /app.jar /app.jar

# New way - layers for dependencies
# WARNING app first to prevent accidental/malicious overwriting of 
#         lib or META-INF files
COPY --from=builder /spring-app/target/dependency/BOOT-INF/classes /app
COPY --from=builder /spring-app/target/dependency/BOOT-INF/lib /app/lib
COPY --from=builder /spring-app/target/dependency/META-INF /app/META-INF

# JDK8 build classloader bug in JDK source code JAR loading workaround shown below
# WARNING For some versions of Spring and JDK's JAR classloader, a fat jar
#         simply does not work. It's also expensive in terms of layers for
#         container images, so we show here how to unpack and use the raw
#         app files themselves
# CMD java -jar -Dsun.misc.URLClassPath.disableJarChecking=true -Dspring.profiles.active="$SPRING_PROFILE" -Dserver.port=$PORT /app.jar
CMD java -cp /app:/app/lib/* -Dspring.profiles.active="$SPRING_PROFILE" -Dserver.port=$PORT $RUN_MAIN_CLASS
