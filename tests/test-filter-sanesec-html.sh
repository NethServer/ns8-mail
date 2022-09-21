#!/bin/sh

mto=${1:?}
mfrom=${2:-"$(id -nu)@$(hostname -f)"}
random=$RANDOM

SANESEC_HTML=$(base64 -d <<<'Ym9keV9ycmc2M3VoajJ1Y3llY2NydXg3ZDgzYTRxZDV1YTV2bmxnd2pwNmI2Zm1wenBvYnpqYWJmdGVodWhyYXhmYnl6enp6eg==')

{
cat - <<EOF
From: <${mfrom}>
To: <${mto}>
Subject: Test Filter Sanesec HTML ${random}
Message-ID: <$(uuidgen)@$(hostname -f)>
Date: $(date -R)
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary="=-kRWkOnY7mEXA/9UDYDai"

--=-kRWkOnY7mEXA/9UDYDai
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Test

--=-kRWkOnY7mEXA/9UDYDai
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: base64

EOF

echo "<html><head></head><body>${SANESEC_HTML}</body></html>" | base64 -w 72
echo ""
echo "--=-kRWkOnY7mEXA/9UDYDai--"
} | curl -s -v --upload-file - --crlf \
    --mail-from "${mfrom}" \
    --mail-rcpt "${mto}" \
    smtp://${MAIL_SERVER:-127.0.0.1}
