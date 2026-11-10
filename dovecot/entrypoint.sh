#!/bin/ash

#
# Copyright (C) 2023 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# shellcheck shell=dash

set -e

if [ $# -eq 0 ]; then
    if [ ! -f /etc/ssl/dovecot/server.key ]; then
        # Generate a self-signed certificate
        openssl req -new -x509 -nodes -days 365 \
            -config /etc/dovecot/dovecot-openssl.cnf \
            -out /etc/ssl/dovecot/server.pem \
            -keyout /etc/ssl/dovecot/server.key
        chmod 0600 /etc/ssl/dovecot/server.key
    fi
    if [ ! -f /etc/ssl/dovecot/dh.pem ]; then
        # copy the default DH number to the persistent volume
        cat /usr/local/lib/templates/dh.pem > /etc/ssl/dovecot/dh.pem
    fi
    reload-config
    exec dovecot -F
else
    exec "${@}"
fi
