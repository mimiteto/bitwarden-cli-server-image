#! /bin/bash

set -e
set -u

HOSTNAME_FILE=/etc/bitwarden/host
USER_FILE=/etc/bitwarden/user
PASSWORD_FILE=/etc/bitwarden/password
export BW_SESSION
export BW_PORT="${BW_PORT:-8087}"
export BW_HOST="${BW_HOST:-"0.0.0.0"}"

bw config server "$(cat "${HOSTNAME_FILE}")"

BW_SESSION=$(bw login "$(cat "${USER_FILE}")" --passwordfile "${PASSWORD_FILE}" --raw)

bw unlock --check

echo "Running 'bw serve' on ${BW_HOST}:${BW_PORT}"
bw serve --hostname "${BW_HOST}" --port "${BW_PORT}"
ex_code=$?
echo "Exited with code ${ex_code}"
exit "${ex_code}"
