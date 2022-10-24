#!/bin/sh

mto=${1:?}
mfrom=${2:-"$(id -nu)@$(hostname -f)"}
random=$RANDOM

SANESEC_SUBJECT=$(base64 -d <<<'cnJnNjNVaGoyVUN5RUNjcnVYN0Q4M0E0cWQ1VUE1dm5sZ3dKcDZiNmZtUFpwT2JaSkFiZnRlaHVoUkFYRmJ5')

curl -s -v --upload-file - --crlf \
    --mail-from "${mfrom}" \
    --mail-rcpt "${mto}" \
    smtp://${MAIL_SERVER:-127.0.0.1} <<EOF
From: <${mfrom}>
To: <${mto}>
Subject: ${SANESEC_SUBJECT}
Message-ID: <$(uuidgen)@$(hostname -f)>
Date: $(date -R)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"

This email should be blocked by the filter
EOF
