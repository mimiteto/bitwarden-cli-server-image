# Bitwarden CLI Server Image

This repo simply follows the example from https://external-secrets.io/main/examples/bitwarden/

## Container image
[![Build and Push Docker Image](https://github.com/mimiteto/bitwarden-cli-server-image/actions/workflows/docker-build-push.yml/badge.svg?branch=master)](https://github.com/mimiteto/bitwarden-cli-server-image/actions/workflows/docker-build-push.yml)

Image expects that there are 3 files within the `/etc/bitwarden` directory, each having only one line:
* host: file should contain the base URL to your vault instance
* user: file should contain your bitwarden user
* password: file should contain your bitwarden password

Image allows for configuration for the host/port via env variables (BW_HOST/BW_PORT) and will default to `0.0.0.0:8087`

You can build and run with:

```bash
export IMAGE_NAME="bitwarden-cli-srv:latest"
docker build -t "${IMAGE_NAME}" -f ./container/Dockerfile ./container
docker run -ti --rm -p 8087:8087 \
    -v /tmp/bitwarden-clientid:/etc/bitwarden/clientid \
    -v /tmp/bitwarden-clientsecret:/etc/bitwarden/clientsecret \
    -v /tmp/bitwarden-host:/etc/bitwarden/host \
    -v /tmp/bitwarden-password:/etc/bitwarden/password \
    ${IMAGE_NAME}
```
or
```bash
export IMAGE_NAME="bitwarden-cli-srv:latest"
docker build -t "${IMAGE_NAME}" -f ./container/Dockerfile ./container
docker run -ti --rm -p 8087:8087 \
    -v /tmp/bitwarden-host:/etc/bitwarden/host \
    -v /tmp/bitwarden-user:/etc/bitwarden/user \
    -v /tmp/bitwarden-password:/etc/bitwarden/password \
    ${IMAGE_NAME}

```

## Helm chart

Helm chart will ease your deployment.
Consider inspecting it, inspecting the image build scripts and then build your image.
Overall, be cautious, as those scripts have direct access to your credentials.

To install the chart, clone the current repository, then run:
```
helm upgrade --install my-bitwarden-cli deployment/bitwarden-cli-srv
```
