ARG BW_CLI_VERSION=2023.12.1
ARG DEBIAN_VERSION=12-slim

FROM debian:${DEBIAN_VERSION} as base
RUN apt-get update && apt-get install -y curl

ARG BW_CLI_VERSION
ENV BW_CLI_VERSION="${BW_CLI_VERSION}"

FROM base as builder
ARG BW_CLI_VERSION
ENV BASE_URL="https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}"
ENV PKG="bw-linux-${BW_CLI_VERSION}.zip"
ENV SHA_FILE="bw-linux-sha256-${BW_CLI_VERSION}.txt"
ENV DOWNLOAD_URL="${BASE_URL}/${PKG}"
ENV SHA_URL="${BASE_URL}/${SHA_FILE}"

RUN apt-get update && apt-get install -y unzip && \
    curl -s -L -o "/tmp/${PKG}" "${DOWNLOAD_URL}" && \
    curl -s -L -o "/tmp/${SHA_FILE}" "${SHA_URL}" && \
    unzip /tmp/${PKG} -d /bw-cli && chmod +x /bw-cli/bw

RUN  if test "$(cat "/tmp/${SHA_FILE}")" != "$(sha256sum "/tmp/${PKG}" | cut -d ' ' -f 1)" ; then exit 1; else echo 'Verification successful'; fi

FROM base as app
COPY --from=builder /bw-cli/bw /usr/local/bin/bw
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/usr/local/bin/entrypoint.sh"]
