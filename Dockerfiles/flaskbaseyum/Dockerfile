# Args
ARG BASE_IMAGE=registry.access.redhat.com/ubi8/python-39
# OR myorg/myapp:latest if overriding via ARGs in Docker build

# Phase 1 - Build
FROM $BASE_IMAGE AS compile-image
# WARNING root required here to run yum
USER root
RUN yum -y --disableplugin=subscription-manager update  && \
  yum -y --disableplugin=subscription-manager install python3 python3-virtualenv && \
  yum -y --disableplugin=subscription-manager clean all

RUN python3 -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /usr/src/app

COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt

#COPY setup.py .
#COPY flask-time-api .
#RUN pip -v install .

# Phase 2 - Run
FROM $BASE_IMAGE as run-image
COPY --from=compile-image /opt/venv /opt/venv
COPY --from=compile-image /usr/src/app /usr/src/app
WORKDIR /usr/src/app
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

# This will be done in the execution image Dockerfile only:-
#CMD ["python3","app.py"]