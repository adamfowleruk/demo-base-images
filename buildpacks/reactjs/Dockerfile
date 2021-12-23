ARG BASE_IMAGE=node:17.2.0-bullseye
ARG RUN_IMAGE=nginx:1.21.4
ARG APP_FOLDER=.

FROM $BASE_IMAGE as build
# Arg linking
ARG APP_FOLDER
# Builder work
WORKDIR /app
ENV PATH=/app/node_modules/.bin:$PATH
COPY ${APP_FOLDER}/package.json ./
COPY ${APP_FOLDER}/package-lock.json ./
RUN npm ci --silent
RUN npm install react-scripts@3.4.1 -g --silent
COPY ${APP_FOLDER}/* ./
RUN pwd && ls -l && ls -la * && npm run build

# production environment
FROM $RUN_IMAGE
COPY --from=build /app/build /usr/share/nginx/html
# EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]