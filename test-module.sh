#!/bin/bash

set -e

LEADER_NODE=$1
IMAGE_URL=$2
shift 2
SSH_KEYFILE=${SSH_KEYFILE:-$HOME/.ssh/id_rsa}

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
    -v .:/home/pwuser/ns8-module:z \
    --volume=site-packages:/home/pwuser/.local/lib/python3.8/site-packages:Z \
    --name rf-core-runner ghcr.io/marketsquare/robotframework-browser/rfbrowser-stable:19.1.1 \
    bash -l -s <<EOF
set -e
echo "$ssh_key" > /home/pwuser/ns8-key
pip install -q -r /home/pwuser/ns8-module/tests/pythonreq.txt
mkdir ~/outputs
cd /home/pwuser/ns8-module
exec robot -v NODE_ADDR:${LEADER_NODE} \
    -v IMAGE_URL:${IMAGE_URL} \
    -v SSH_KEYFILE:/home/pwuser/ns8-key \
    --name mail \
    --skiponfailure unstable \
    -d ~/outputs ${@} /home/pwuser/ns8-module/tests/
EOF
