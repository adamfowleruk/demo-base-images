# The default image with Flask and Virtualenv installed
ARG BASE_IMAGE=harbor.shared.12factor.xyz/adamf/python-flask-base-image:v1-debian-bullseye
# The default folder within the target to build (usually the root folder)
ARG APP_FOLDER=.

FROM $BASE_IMAGE
WORKDIR /usr/src/app
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

# Copy actual app over
COPY ${APP_FOLDER}/* .

# This will be done in the execution image Dockerfile only:-
CMD ["flask","run","--no-debugger"]