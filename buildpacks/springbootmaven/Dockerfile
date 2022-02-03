# Args
# ARG RUNNER_BASE_IMAGE=openjdk:8u312-jre-slim-bullseye
ARG RUNNER_BASE_IMAGE=harbor.shared.12factor.xyz/adamf/java-spring-base-image:v1-debian-bullseye
ARG RUN_MAIN_CLASS=com.vmware.myapp.MyApp
ARG SPRING_PROFILE=k8s
ARG PORT=4000

# Stage 2 - runtime
FROM $RUNNER_BASE_IMAGE

# JDK8 build classloader bug in JDK source code JAR loading workaround shown below
# WARNING For some versions of Spring and JDK's JAR classloader, a fat jar
#         simply does not work. It's also expensive in terms of layers for
#         container images, so we show here how to unpack and use the raw
#         app files themselves
# CMD java -jar -Dsun.misc.URLClassPath.disableJarChecking=true -Dspring.profiles.active="$SPRING_PROFILE" -Dserver.port=$PORT /app.jar
CMD java -cp /app:/app/lib/* -Dspring.profiles.active="$SPRING_PROFILE" -Dserver.port=$PORT $RUN_MAIN_CLASS
