# Bitwarden CLI Server Image

This repo simply follows the example from https://external-secrets.io/main/examples/bitwarden/

## Container image
[![Build and Push Docker Image](https://github.com/mimiteto/bitwarden-cli-server-image/actions/workflows/docker-build-push.yml/badge.svg?branch=master)](https://github.com/mimiteto/bitwarden-cli-server-image/actions/workflows/docker-build-push.yml)

Image expects that there are 3 files within the `/etc/bitwarden` directory, each having only one line:
* host: file should contain the base URL to your vault instance
* user: file should contain your bitwarden user
* password: file should contain your bitwarden password

Image allows for configuration for the host/port via env variables (BW_HOST/BW_PORT) and will default to `0.0.0.0:8087`

## Helm chart

Helm chart will ease your deployment.
Consider inspecting it, inspecting the image build scripts and then build your image.
Overall, be cautious, as those scripts have direct access to your credentials.

To install the chart, clone the current repository, then run:
```
helm upgrade --install my-bitwarden-cli deployment/bitwarden-cli-srv
```
