#!/bin/sh

credentials=${1:?}
mto=${2:?}
mfrom=${3:-"$(id -nu)@$(hostname -f)"}
random=$RANDOM

curl -k -s -v --upload-file - --crlf \
    --user "${credentials}" \
    --mail-from "${mfrom}" \
    --mail-rcpt "${mto}" \
    smtps://127.0.0.2 <<EOF
From: <${mfrom}>
To: <${mto}>
Subject: Test ${random}
Message-ID: <$(uuidgen)@$(hostname -f)>
Date: $(date -R)
Content-Type: text/plain; charset="UTF-8"

Hello this is a test ${random}
EOF
