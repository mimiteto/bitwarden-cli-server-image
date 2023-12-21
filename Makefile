CHART_DIR := deployment/bitwarden-cli-srv
USERNAME := mimiteto
REPO_NAME := bitwarden-cli-server-image

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

.PHONY: publish-chart
publish-chart: sync-helm
	@helm package $(CHART_DIR)
	@helm repo index . --url https://$(USERNAME).github.io/$(REPO_NAME)
	@git add $(CHART_DIR)
	@git commit -m "Publishing chart version $(shell cat VERSION)-$(shell cat SCRIPTS_VERSION)"
	@git push origin master
