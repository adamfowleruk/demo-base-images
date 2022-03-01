# Args
## Buildtime and Image definition args
ARG BUILDER_BASE_IMAGE=mcr.microsoft.com/dotnet/sdk:6.0
ARG RUNNER_BASE_IMAGE=mcr.microsoft.com/dotnet/runtime:6.0
ARG APP_FOLDER=.
ARG BUILD_TYPE=release

FROM $BUILDER_BASE_IMAGE as builder
## Import global ARG values
ARG APP_FOLDER
ARG BUILD_TYPE

WORKDIR /source

# copy csproj and restore as distinct layers
COPY ${APP_FOLDER}/*.csproj .
RUN dotnet restore

# copy and publish app and libraries
COPY ${APP_FOLDER} .
RUN dotnet publish -c ${BUILD_TYPE} -o /app --no-restore

# final stage/image
FROM $RUNNER_BASE_IMAGE as run-image
WORKDIR /app
COPY --from=builder /app .
ENTRYPOINT ["dotnet", "dotnetapp.dll"]
