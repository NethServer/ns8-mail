#!/bin/ash

#
# Copyright (C) 2022 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# shellcheck shell=dash

set -e

if [ $# -eq 0 ]; then
    if [ ! -f /srv/pcdb.sqlite ]; then
        (
            cd /srv
            sqlite3 pcdb.sqlite '.read /etc/postfix/pcdb-init.sql'
        )
    fi
    if [ ! -f /etc/ssl/postfix/fullchain.pem ]; then
        (
            cd /etc/postfix
            postfix tls new-server-cert nethserver.test
            umask 077
            cat key-*.pem cert-*.pem > /etc/ssl/postfix/fullchain.pem
            rm -f key-*.pem cert-*.pem
        )
    fi
    reload-config
    exec /usr/sbin/postfix start-fg
else
    exec "${@}"
fi
