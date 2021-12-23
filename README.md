# demo-base-images
Base OCI image definitions for use by pipelines

This repository holds base and intermediate image definitions.

None of these base images are executable themselves. Think of them as better bases for apps to be deployed to, with known versioned dependencies and no licensing issues.

## Base images

I've pulled sensible base images for each Linux option as a base, then created
an intermediate base image for each runtime. E.g. python-flask or java-spring-boot.

Base images can be found in the `Dockerfiles` folder.

These provide builder images with (ideally) the dependencies for target patterns
already built in with 'known-good' versions of libraries. (Currently this is only true of flask).

OS and runtime base images available:-

- Debian Bullseye (or any apt based OS)
 - Python Flask
 - Java Spring Boot (Maven or Gradle) (Work in progress)
 - ReactJS (work in progress)
- Ubuntu Jammy
 - Python base image (Python environment only)
 - Python Flask
- SUSE 15.3
 - Python Flask
- RedHat Linux UBI8
 - Python Flask

Note: You should be able to override via the BASE_IMAGE argument the precise versions of the above
that the builder image is based on. This allows you to upgrade the whole OS without varying
your runtime libraries or version. Useful for applying OS CVE fixes.

## Images and tags

The final images can be found at:-

- Custom python base image: https://harbor.shared.12factor.xyz/adamf/ubuntu-python-base-image
- Flask base: https://harbor.shared.12factor.xyz/adamf/python-flask-base-image
- Java builder image: To be published soon

The above images each have the same set of tags available, representing the version of the buildpack and the version of the base OS they are built on. Currently the list is:-

- v1-debian-bullseye
- v1-redhat-ubi8
- v1-ubuntu-jammy-20211122
- v1-suse-15.3.17.8.42

The sizes of the above vary greatly. For example, the final Python Flask demo app (just a simple single rest api URL) is this size in each OS currently:-

- SUSE 48.62MB
- Ubuntu: 72.85MB
- RedHat UBI8: 308MB
- Debian Bullseye: 339.30MB

In comparison, the final java app on debisn bullseye slim is only 71.15MB. So both OS base images and how the runtime environment is constructed have a large effect on final image size.

## Buildpack images

Once there is a choice of base builder and runtime images, a buildpack image uses these
to build and then containerise the app ready for running.

Buildpack images can be found in the `buildpacks` folder.

Current runtime buildpack images available:-

- Python Flask REST API
  - works, Flask and Python dependencies are (statically) vendored into the image ready for the developer
- Spring Boot via Maven
  - works, Maven dependencies are dynamic and not vendored into the image
- Spring Boot via Gradle
  - A work in progress

## Branches

There are two branches here used by CI/CD, they are:-

- main - used for Production tier CD pipelines, or Sandbox pipelines testing current apps against new platform changes
- develop - used for testing changes to these Dockerfiles before being released to app teams

## CI/CD

See the complementary demo-paving repository below, under the `app-pipeline/test/delivery-integration` Golden Image pipeline, and the `app-pipeline/test/adsb-shared` demo full stack app pipeline, folders.

https://github.com/adamfowleruk/demo-paving

## License

All Dockerfiles and other build definition files in this repository are licensed under the Apache-2.0 license.
