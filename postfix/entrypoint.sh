#!/bin/ash

#
# Copyright (C) 2022 Nethesis S.r.l.
# http://www.nethesis.it - nethserver@nethesis.it
#
# This script is part of NethServer.
#
# NethServer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License,
# or any later version.
#
# NethServer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with NethServer.  If not, see COPYING.
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
