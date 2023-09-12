#!/bin/bash

#
# Copyright (C) 2023 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# shellcheck shell=dash

set -e

if [ $# -eq 0 ]; then
    if [ ! -f /etc/ssl/dovecot/dovecot.key ]; then
        mkdir -v /etc/dovecot/ssl
        cat <<EOF >/etc/dovecot/dovecot-openssl.cnf
[ req ]
default_bits = 2048
encrypt_key = yes
distinguished_name = req_dn
x509_extensions = cert_type
prompt = no

[ req_dn ]
# country (2 letter code)
#C=FI

# State or Province Name (full name)
#ST=

# Locality Name (eg. city)
#L=Helsinki

# Organization (eg. company)
#O=Dovecot

# Organizational Unit Name (eg. section)
OU=IMAP server

# Common Name (*.example.com is also possible)
CN=imap.example.com

# E-mail contact
emailAddress=postmaster@example.com

[ cert_type ]
nsCertType = server
EOF
        export OPENSSLCONFIG=/etc/dovecot/dovecot-openssl.cnf && /usr/share/dovecot/mkcert.sh
    fi
    reload-config
    exec dovecot -F
else
    exec "${@}"
fi
