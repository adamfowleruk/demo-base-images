# Args
## Buildtime and Image definition args
# ARG BUILDER_BASE_IMAGE=openjdk:8-jdk
# ARG RUNNER_BASE_IMAGE=openjdk:8-jdk
# Note: Slim OpenJDK doesn't include WGET, used to fetch the latest gradle

ARG BUILDER_BASE_IMAGE=openjdk:8u312-jdk-slim-bullseye
ARG RUNNER_BASE_IMAGE=openjdk:8u312-jre-slim-bullseye
ARG APP_FOLDER=.
ARG APP_JAR_FILENAME=target/*.jar

ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"

## Runtime args
# ARG RUN_SPRING_PROFILE=myprofile
# ARG RUN_PORT=5050

# Stage 1 - build time
FROM $BUILDER_BASE_IMAGE as builder
## Import global ARG values
ARG APP_FOLDER
ARG APP_JAR_FILENAME
ARG MAVEN_VERSION
ARG USER_HOME_DIR

ENV BUILD_JAR_FILENAME=$APP_JAR_FILENAME



RUN apt-get update && \
  apt-get install -y --no-install-recommends curl tar bash && \
  apt-get clean
# RUN apk add --no-cache curl tar bash
RUN mkdir -p /usr/share/maven && \
  curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
  ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
# speed up Maven JVM a bit
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"





WORKDIR /spring-app

COPY ${APP_FOLDER}/* .

# EXPOSE 4000

RUN export && pwd && ls -l && ls -l * && \
  mvn verify && \
  ls -a && ls -a * && \
  mv ${BUILD_JAR_FILENAME} /app.jar
# The above leaves the source code in place... larger container image size
# So next we use a second stage to eliminate those temporary files


# Stage 2 - runtime
FROM $RUNNER_BASE_IMAGE

COPY --from=builder /app.jar /app.jar

# ENV SPRING_PROFILE $RUN_SPRING_PROFILE
# ENV PORT $RUN_PORT

#CMD java -jar -Dspring.profiles.active="in-memory" -Dserver.port=4000 /app.jar
#CMD java -jar -Dspring.profiles.active="postgres-k8s" -Dserver.port=4000 /app.jar
CMD java -jar -Dspring.profiles.active="$SPRING_PROFILE" -Dserver.port=$PORT /app.jar
