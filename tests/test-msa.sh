#!/bin/sh

#
# Copyright (C) 2025 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

mto=${1:?missing mto}
mfrom=${2:?missing mfrom}
credentials=${3}
random=$RANDOM

if [[ ${MAIL_SERVER} != *://* ]] ; then
    # Fall back value, with smtps port 465
    MAIL_SERVER="smtps://${MAIL_SERVER:-127.0.0.1}"
fi

curl -k -s -v --upload-file - --crlf \
    ${credentials:+--user "${credentials}"} \
    --mail-from "${mfrom}" \
    --mail-rcpt "${mto}" \
    ${MAIL_SERVER}/${EHLO_HOST:-${mfrom/#*@/}} <<EOF
From: <${mfrom}>
To: <${mto}>
Subject: Test ${random}
Message-ID: <$(uuidgen)@${mfrom/#*@/}>
Date: $(date -R)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"

Hello this is a test ${random}
EOF
