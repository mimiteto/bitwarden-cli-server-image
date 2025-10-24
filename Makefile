CHART_DIR := deployment/bitwarden-cli-srv
USERNAME := mimiteto
REPO_NAME := bitwarden-cli-server-image
CONTAINER_REPO_NAME := ghcr.io/$(USERNAME)/$(REPO_NAME)


.PHONY: help
help:
	@echo "Available make targets:"
	@echo "  container-build   - Build the Docker container image with version tags."
	@echo "  sync-helm         - Sync Helm chart versions with VERSION and SCRIPTS_VERSION files."
	@echo "  template-helm     - Render Helm chart templates with synced versions."
	@echo "  test-helm         - Test Helm chart rendering against predefined values files."

.PHONY: container-build
container-build:
	docker build -t ghcr.io/$(USERNAME)/$(REPO_NAME):$(shell cat VERSION)-$(shell cat SCRIPTS_VERSION) -f container/Dockerfile container/

.PHONY: sync-helm
sync-helm:
	@sed -i 's/^appVersion: .*/appVersion: "$(shell cat VERSION)-$(shell cat SCRIPTS_VERSION)"/g' deployment/bitwarden-cli-srv/Chart.yaml
	@sed -i 's/^version: .*/version: "$(shell cat SCRIPTS_VERSION)"/g' deployment/bitwarden-cli-srv/Chart.yaml

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
