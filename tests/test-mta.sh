#!/bin/sh

mto=${1:?}
mfrom=${2:-"$(id -nu)@$(hostname -f)"}
random=$RANDOM

curl -s -v --upload-file - --crlf \
    --mail-from "${mfrom}" \
    --mail-rcpt "${mto}" \
    smtp://${MAIL_SERVER:-127.0.0.1} <<EOF
From: <${mfrom}>
To: <${mto}>
Subject: Test ${random}
Message-ID: <$(uuidgen)@$(hostname -f)>
Date: $(date -R)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"

Hello this is a test ${random}
EOF
