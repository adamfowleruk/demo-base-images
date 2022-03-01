# Args
## Buildtime and Image definition args
ARG BUILDER_BASE_IMAGE=mcr.microsoft.com/dotnet/sdk:6.0.200-bullseye-slim-amd64
ARG RUNNER_BASE_IMAGE=mcr.microsoft.com/dotnet/aspnet:6.0.2-bullseye-slim-amd64
ARG APP_FOLDER=.
ARG BUILD_TYPE=release

FROM $BUILDER_BASE_IMAGE as builder
## Import global ARG values
ARG APP_FOLDER
ARG BUILD_TYPE

WORKDIR /source

# copy csproj and restore as distinct layers
COPY ${APP_FOLDER}/*.sln .
COPY ${APP_FOLDER}/*.csproj .
RUN dotnet restore

# copy and publish app and libraries
COPY ${APP_FOLDER} .
ENV BUILD_TYPE ${BUILD_TYPE}
RUN dotnet publish -c $BUILD_TYPE -o /app --no-restore

# final stage/image
FROM $RUNNER_BASE_IMAGE as run-image
WORKDIR /app
COPY --from=builder /app .
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
