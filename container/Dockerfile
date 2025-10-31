ARG BW_CLI_VERSION=2025.10.1
ARG DEBIAN_VERSION=12-slim

FROM debian:${DEBIAN_VERSION} AS base
RUN apt-get update && apt-get install -y curl

ARG BW_CLI_VERSION
ENV BW_CLI_VERSION="${BW_CLI_VERSION}"

FROM base AS builder
ARG BW_CLI_VERSION
ENV DOWNLOAD_URL="https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-linux-${BW_CLI_VERSION}.zip"
ENV PKG="bw-linux-${BW_CLI_VERSION}.zip"

RUN apt-get update && apt-get install -y unzip && \
    curl -s -L -o "/tmp/${PKG}" "${DOWNLOAD_URL}" && \
    unzip "/tmp/${PKG}" -d /bw-cli && chmod +x /bw-cli/bw

FROM base AS app
COPY --from=builder /bw-cli/bw /usr/local/bin/bw
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/usr/local/bin/entrypoint.sh"]
