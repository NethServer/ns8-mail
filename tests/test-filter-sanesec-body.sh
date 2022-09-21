#!/bin/sh

mto=${1:?}
mfrom=${2:-"$(id -nu)@$(hostname -f)"}
random=$RANDOM

SANESEC_BODY=$(base64 -d <<<'Ym9keV9ycmc2M1VoajJVQ3lFQ2NydVg3RDgzQTRxZDVVQTV2bmxnd0pwNmI2Zm1QWjBhamRqa3dqblNTRGZzZGZzZGZud2VyZA==')

curl -s -v --upload-file - --crlf \
    --mail-from "${mfrom}" \
    --mail-rcpt "${mto}" \
    smtp://${MAIL_SERVER:-127.0.0.1} <<EOF
From: <${mfrom}>
To: <${mto}>
Subject: Test Filter Sanesec Body ${random}
Message-ID: <$(uuidgen)@$(hostname -f)>
Date: $(date -R)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"

${SANESEC_BODY}
EOF
