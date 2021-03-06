ARG BASE_IMAGE=node:17.3.0-bullseye
ARG RUN_IMAGE=nginx:1.21.4
ARG APP_FOLDER=.
ARG NGINX_CONF=/etc/nginx/nginx.conf

FROM $BASE_IMAGE as build
# Arg linking
ARG APP_FOLDER
ARG NGINX_CONF
# Builder work
WORKDIR /app
ENV PATH=/app/node_modules/.bin:$PATH

# Copy custom NGINX conf file, if specified
COPY ${NGINX_CONF} /nginx.conf

# NPM
# COPY ${APP_FOLDER}/package.json ./
# COPY ${APP_FOLDER}/package-lock.json ./
# RUN npm install -g npm@8.3.0
# RUN npm ci --silent
# RUN npm install react-scripts@5.0.0 -g --silent
# COPY ${APP_FOLDER}/ ./
# RUN pwd && ls -l && ls -la * && npm run build

# YARN
COPY ${APP_FOLDER}/package.json ./
COPY ${APP_FOLDER}/yarn.lock ./
RUN yarn install --immutable
COPY ${APP_FOLDER}/ ./
RUN pwd && ls -l && ls -la * && yarn build && ls build/

# production environment
FROM $RUN_IMAGE as run
COPY --from=build /nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]