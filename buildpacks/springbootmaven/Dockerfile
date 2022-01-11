# Args
## Buildtime and Image definition args
ARG BUILDER_BASE_IMAGE=openjdk:8u312-jdk-slim-bullseye
ARG RUNNER_BASE_IMAGE=openjdk:8u312-jre-slim-bullseye
ARG APP_FOLDER=.
ARG APP_JAR_FILENAME=target/*.jar

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


# Stage 1 - Build the spring boot app
WORKDIR /spring-app

COPY ${APP_FOLDER}/* .

RUN mvn clean package spring-boot:repackage && \
  mv ${APP_JAR_FILENAME} /app.jar
# Useful debugging tools to include in the above:-
# export && pwd && ls -l && ls -l * && \
#  ls -l && ls -l * && \
# The above leaves the source code in place... larger container image size
# So next we use a second stage to eliminate those temporary files


# Stage 2 - runtime
FROM $RUNNER_BASE_IMAGE

COPY --from=builder /app.jar /app.jar

CMD java -jar -Dspring.profiles.active="$SPRING_PROFILE" -Dserver.port=$PORT /app.jar
