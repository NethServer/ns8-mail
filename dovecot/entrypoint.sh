#!/bin/bash

#
# Copyright (C) 2023 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# shellcheck shell=dash

set -e

if [ $# -eq 0 ]; then
    if [ ! -f /etc/ssl/dovecot/server.key ]; then
        mkdir -v /etc/dovecot/ssl
        export OPENSSLCONFIG=/etc/dovecot/dovecot-openssl.cnf && /usr/share/dovecot/mkcert.sh
        cp /etc/dovecot/ssl/dovecot.key /etc/ssl/dovecot/server.key
        cp /etc/dovecot/ssl/dovecot.pem /etc/ssl/dovecot/server.pem
        rm -rf /etc/dovecot/ssl/
    fi
    reload-config
    exec dovecot -F
else
    exec "${@}"
fi
