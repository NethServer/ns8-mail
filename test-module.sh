#!/bin/bash

#
# Copyright (C) 2024 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

#
# Hint: access the test logs on HTTP port 8000 with this command:
#
#     python -mhttp.server -d tests/outputs/ 8000 &
#

set -e

SSH_KEYFILE=${SSH_KEYFILE:-$HOME/.ssh/id_rsa}

LEADER_NODE="${1:?missing LEADER_NODE argument}"
IMAGE_URL="${2:?missing IMAGE_URL argument}"
shift 2

ssh_key="$(< $SSH_KEYFILE)"

cleanup() {
    set +e
    podman cp rf-core-runner:/home/pwuser/outputs tests/
    podman stop rf-core-runner
    podman rm rf-core-runner
}

trap cleanup EXIT
podman run -i \
    --network=host \
    --volume=.:/home/pwuser/ns8-module:z \
    --volume=site-packages:/home/pwuser/.local/lib/python3.12/site-packages:z \
    --name rf-core-runner ghcr.io/marketsquare/robotframework-browser/rfbrowser-stable:19.1.2 \
    bash -l -s <<EOF
set -e
echo "$ssh_key" > /home/pwuser/ns8-key
pip install -q -r /home/pwuser/ns8-module/tests/pythonreq.txt
mkdir ~/outputs
cd /home/pwuser/ns8-module
exec robot -v NODE_ADDR:${LEADER_NODE} \
    -v IMAGE_URL:${IMAGE_URL} \
    -v SSH_KEYFILE:/home/pwuser/ns8-key \
    --name "$(basename $PWD)" \
    --skiponfailure unstable \
    -d ~/outputs ${@} /home/pwuser/ns8-module/tests/
EOF
