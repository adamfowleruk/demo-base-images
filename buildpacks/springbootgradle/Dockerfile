# Args
## Buildtime and Image definition args
# ARG BUILDER_BASE_IMAGE=openjdk:8-jdk
# ARG RUNNER_BASE_IMAGE=openjdk:8-jdk
# Note: Slim OpenJDK doesn't include WGET, used to fetch the latest gradle
ARG BUILDER_BASE_IMAGE=openjdk:8u312-jdk-bullseye
ARG RUNNER_BASE_IMAGE=openjdk:8u312-jre-slim-bullseye
ARG BUILD_GRADLE_VERSION=6.9
ARG BUILD_GRADLE_DOWNLOAD_SHA256=765442b8069c6bee2ea70713861c027587591c6b1df2c857a23361512560894e
ARG BUILD_GRADLE_HOME=/opt/gradle
ARG APP_FOLDER=.
ARG APP_JAR_FILENAME=target/*.jar
## Runtime args
ARG RUN_SPRING_PROFILE=myprofile
ARG RUN_PORT=5050

# Stage 1 - build time
FROM $BUILDER_BASE_IMAGE as builder

# Default gradle version in the above is v4.0.1 - waaaaay too old!
# TODO FIX WHY THESE ARGS DO NOT END UP IN THE ENV VARIABLES IN RUN
ENV GRADLE_DOWNLOAD_SHA256 765442b8069c6bee2ea70713861c027587591c6b1df2c857a23361512560894e
ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 6.9
ENV BUILD_JAR_FILENAME target/*.jar

RUN set -o errexit -o nounset \
  && echo "Downloading Gradle" \
  && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
  \
  && echo "Checking download hash" \
  && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - \
  \
  && echo "Installing Gradle" \
  && unzip gradle.zip \
  && rm gradle.zip \
  && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" 
  # \
  # && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
  # \
  # && echo "Adding gradle user and group" \
  # && groupadd --system --gid 1000 gradle \
  # && useradd --system --gid gradle --uid 1000 --shell /bin/bash --create-home gradle \
  # && mkdir /home/gradle/.gradle \
  # && chown --recursive gradle:gradle /home/gradle

COPY $APP_FOLDER/* /spring-app
WORKDIR /spring-app
# Value from WORKDIR name overrides the project name if it doesn't match, and thus the final JAR file name!

# EXPOSE 4000

RUN pwd && \
  ${GRADLE_HOME}/bin/gradle clean assemble \
  && mv ${BUILD_JAR_FILENAME} /app.jar
# The above leaves the source code in place... larger container image size
# So next we use a second stage to eliminate those temporary files


# Stage 2 - runtime
FROM $RUNNER_BASE_IMAGE

COPY --from=builder /app.jar /app.jar

ENV SPRING_PROFILE $RUN_SPRING_PROFILE
ENV PORT $RUN_PORT

#CMD java -jar -Dspring.profiles.active="in-memory" -Dserver.port=4000 /app.jar
#CMD java -jar -Dspring.profiles.active="postgres-k8s" -Dserver.port=4000 /app.jar
CMD java -jar -Dspring.profiles.active="$SPRING_PROFILE" -Dserver.port=$PORT /app.jar
