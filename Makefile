CHART_DIR := deployment/bitwarden-cli-srv
USERNAME := mimiteto
REPO_NAME := bitwarden-cli-server-image
CONTAINER_REPO_NAME := ghcr.io/$(USERNAME)/$(REPO_NAME)
SCRIPTS_VERSION := $(shell cat SCRIPTS_VERSION)
VERSION := $(shell cat VERSION)
VERSION_TAG := $(shell cat VERSION)-$(shell cat SCRIPTS_VERSION)


.PHONY: help
help:
	@echo "Available make targets:"
	@echo "  container-build--multiarch           - Build the Docker container image with version tags."
	@echo "  container-build-and-push-multiarch   - Build the Docker container image with version tags."
	@echo "  sync-helm                            - Sync Helm chart versions with VERSION and SCRIPTS_VERSION files."
	@echo "  template-helm                        - Render Helm chart templates with synced versions."
	@echo "  test-helm                            - Test Helm chart rendering against predefined values files."


.PHONY: container-build-and-push-multiarch
container-build-and-push-multiarch:
	@echo "Building multi-architecture Docker image for platforms: linux/amd64,linux/arm64"
	docker buildx create --use --name multiarch-builder 2>/dev/null || docker buildx use multiarch-builder
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg BW_CLI_VERSION=$(VERSION) \
		--tag $(CONTAINER_REPO_NAME):$(VERSION_TAG) \
		--push \
		-f container/Dockerfile \
		container/

.PHONY: container-build-multiarch
container-build-multiarch:
	@echo "Building multi-architecture Docker image for platforms: linux/amd64,linux/arm64"
	docker buildx create --use --name multiarch-builder 2>/dev/null || docker buildx use multiarch-builder
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg BW_CLI_VERSION=$(VERSION) \
		--tag $(CONTAINER_REPO_NAME):$(VERSION_TAG) \
		-f container/Dockerfile \
		container/


.PHONY: sync-helm
sync-helm:
	@sed -i 's/^appVersion: .*/appVersion: "$(shell cat VERSION)-$(shell cat SCRIPTS_VERSION)"/g' deployment/bitwarden-cli-srv/Chart.yaml
	@sed -i 's/^version: .*/version: "$(shell cat SCRIPTS_VERSION)"/g' deployment/bitwarden-cli-srv/Chart.yaml
	@sed -i 's/^ARG BW_CLI_VERSION=.*/ARG BW_CLI_VERSION=$(shell cat VERSION)/g' container/Dockerfile

.PHONY: template-helm
template-helm: sync-helm
	helm template deployment/bitwarden-cli-srv --set connectionSecretName=operator-created-secret

.PHONY: test-helm
test-helm: sync-helm
	@echo "Testing Default values"
	@helm template deployment/bitwarden-cli-srv -f .resources/values/default.yaml > .resources/renders/default.yaml
	@echo "Diff for default values:"
	@git diff .resources/renders/default.yaml
	@echo "Testing deployment with ingress values"
	@helm template deployment/bitwarden-cli-srv -f .resources/values/ingress.yaml > .resources/renders/ingress.yaml
	@echo "Diff for ingress values"
	@git diff .resources/renders/ingress.yaml
	@echo "Testing deployment with netpol values"
	@helm template deployment/bitwarden-cli-srv -f .resources/values/netpol.yaml > .resources/renders/netpol.yaml
	@git diff .resources/renders/netpol.yaml
