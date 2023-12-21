# Bitwarden CLI Server Image

This repo simply follows the example from https://external-secrets.io/main/examples/bitwarden/

## Container image
[![Build and Push Docker Image](https://github.com/mimiteto/bitwarden-cli-server-image/actions/workflows/docker-build-push.yml/badge.svg?branch=master)](https://github.com/mimiteto/bitwarden-cli-server-image/actions/workflows/docker-build-push.yml)

Image expects that there are 3 files within the `/etc/bitwarden` directory, each having only one line:
* host: file should contain the base URL to your vault instance
* username: file should contain your bitwarden user
* password: file should contain your bitwarden password

Image allows for configuration for the host/port via env variables (BW_HOST/BW_PORT) and will default to `0.0.0.0:8087`

## Helm chart

### Add Helm Repository
To add the Helm chart repository:

```bash
helm repo add bitwarden-cli https://mimiteto.github.io/bitwarden-cli-server-image
helm repo update
```

### Install the `bitwarden-cli-srv` Chart

To install the `bitwarden-cli-srv` chart, run the following command:
```bash
helm upgrade --install my-bitwarden-cli bitwarden-cli/bitwarden-cli-srv
```
Replace `my-bitwarden` with the desired release name for your deployment. You can specify additional configuration options using `--set` or provide a YAML file using `-f`.
Uninstalling the Chart

To uninstall the bitwarden-cli-srv chart:
```bash
helm uninstall my-bitwarden
```
