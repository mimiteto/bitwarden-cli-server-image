# Bitwarden CLI Server Image

This repo simply follows the example from https://external-secrets.io/main/examples/bitwarden/

## Container image
[![Build and Push Docker Image](https://github.com/mimiteto/bitwarden-cli-server-image/actions/workflows/docker-build-push.yml/badge.svg?branch=master)](https://github.com/mimiteto/bitwarden-cli-server-image/actions/workflows/docker-build-push.yml)

Image expects that there are 3 files within the `/etc/bitwarden` directory, each having only one line:
* host: file should contain the base URL to your vault instance
* username: file should contain your bitwarden user
* password: file should contain your bitwarden password

Image allows for configuration for the host/port via env variables (BW_HOST/BW_PORT) and will default to `0.0.0.0:8087`

