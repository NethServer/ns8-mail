#!/bin/sh

mto=${1:?missing mto}
mfrom=${2:?missing mfrom}
credentials=${3:?missing credentials}
random=$RANDOM

curl -k -s -v --upload-file - --crlf \
    --user "${credentials}" \
    --mail-from "${mfrom}" \
    --mail-rcpt "${mto}" \
    smtps://${MAIL_SERVER:-127.0.0.1} <<EOF
From: <${mfrom}>
To: <${mto}>
Subject: Test ${random}
Message-ID: <$(uuidgen)@$(hostname -f)>
Date: $(date -R)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"

Hello this is a test ${random}
EOF
