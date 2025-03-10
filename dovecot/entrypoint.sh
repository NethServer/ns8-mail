#!/bin/ash

#
# Copyright (C) 2023 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# shellcheck shell=dash

set -e

if [ $# -eq 0 ]; then
    if [ ! -f /etc/ssl/dovecot/server.key ]; then
        # resume the apk post-install script to
        # generate a self-signed certificate
        dovecot-post-install
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
