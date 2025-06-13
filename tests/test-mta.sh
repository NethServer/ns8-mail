#!/bin/sh

mto=${1:?missing mto}
mfrom=${2:?missing mfrom}
random=$RANDOM

curl -s -v --upload-file - --crlf \
    --mail-from "${mfrom}" \
    --mail-rcpt "${mto}" \
    smtp://${MAIL_SERVER:-127.0.0.1}/${EHLO_HOST:-${mfrom/#*@/}} <<EOF
From: <${mfrom}>
To: <${mto}>
Subject: Test ${random}
Message-ID: <$(uuidgen)@${mfrom/#*@/}>
Date: $(date -R)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"

Hello this is a test ${random}
EOF
