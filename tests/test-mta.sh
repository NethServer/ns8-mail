#!/bin/sh

mto=${1:?}
mfrom=${2:-"$(id -nu)@$(hostname -f)"}
random=$RANDOM

curl -s -v --upload-file - --crlf \
    --mail-from "${mfrom}" \
    --mail-rcpt "${mto}" \
    smtp://127.0.0.2 <<EOF
From: <${mfrom}>
To: <${mto}>
Subject: Test ${random}
Message-ID: <$(uuidgen)@$(hostname -f)>
Date: $(date -R)
Content-Type: text/plain; charset="UTF-8"

Hello this is a test ${random}
EOF
