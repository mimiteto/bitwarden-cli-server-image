#! /bin/bash

set -e
set -u

HOSTNAME_FILE=/etc/bitwarden/host
USER_FILE=/etc/bitwarden/user
PASSWORD_FILE=/etc/bitwarden/password
CLIENTID_FILE=/etc/bitwarden/clientid
CLIENTSECRET_FILE=/etc/bitwarden/clientsecret

export BW_SESSION
export BW_PORT="${BW_PORT:-8087}"
export BW_HOST="${BW_HOST:-"0.0.0.0"}"
export BW_CLIENTID
export BW_CLIENTSECRET

if [ ! -e "${HOSTNAME_FILE}" ]; then
    echo "Host file ${HOSTNAME_FILE} does not exist, exiting."
    exit 1
fi

bw config server "$(cat "${HOSTNAME_FILE}")"

if [ -e "${CLIENTID_FILE}" ] && [ -e "${CLIENTSECRET_FILE}" ]; then
    BW_CLIENTID="$(cat "${CLIENTID_FILE}")"
    BW_CLIENTSECRET="$(cat "${CLIENTSECRET_FILE}")"
    if [ -z "${BW_CLIENTID}" ] || [ -z "${BW_CLIENTSECRET}" ]; then
        echo "Client ID or Client Secret is empty, exiting."
        exit 1
    fi
    echo "Using apikey to log in. Key in use ${BW_CLIENTID}"
    bw login --apikey --raw
    BW_SESSION=$(bw unlock --passwordfile "${PASSWORD_FILE}" --raw)
else
    username=$(cat "${USER_FILE}")
    echo "Using username and password to log in. Username in use ${username}"
    BW_SESSION=$(bw login "${username}" --passwordfile "${PASSWORD_FILE}" --raw)
fi

bw unlock --check

echo "Running 'bw serve' on ${BW_HOST}:${BW_PORT}"
bw serve --hostname "${BW_HOST}" --port "${BW_PORT}"
ex_code=$?
echo "Exited with code ${ex_code}"
exit "${ex_code}"
