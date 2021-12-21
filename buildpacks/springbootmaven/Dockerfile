# Args
## Buildtime and Image definition args
# ARG BUILDER_BASE_IMAGE=openjdk:8-jdk
# ARG RUNNER_BASE_IMAGE=openjdk:8-jdk
# Note: Slim OpenJDK doesn't include WGET, used to fetch the latest gradle
ARG BUILDER_BASE_IMAGE=openjdk:8u312-jdk-bullseye
ARG RUNNER_BASE_IMAGE=openjdk:8u312-jre-slim-bullseye
ARG APP_FOLDER=.
ARG APP_JAR_FILENAME=target/*.jar
## Runtime args
ARG RUN_SPRING_PROFILE=myprofile
ARG RUN_PORT=5050

# Stage 1 - build time
FROM $BUILDER_BASE_IMAGE as builder

ENV BUILD_JAR_FILENAME target/*.jar

COPY $APP_FOLDER/* /spring-app
WORKDIR /spring-app
# Value from WORKDIR name overrides the project name if it doesn't match, and thus the final JAR file name!

# EXPOSE 4000

RUN pwd && \
  ./mvnw verify \
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
