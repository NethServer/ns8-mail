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
    if [ ! -f /etc/ssl/dovecot/server.key ]; then
        # resume the apk post-install script to
        # generate a self-signed certificate
        dovecot-post-install
    fi
    reload-config
    if grep -q FIRSTBOOT /etc/ssl/dovecot/dh.pem ; then
        (
            # Only the first time Dovecot is started,
            # generate in background a new DH prime
            cd /etc/ssl/dovecot ; umask 077
            openssl dhparam -out dh.pem.tmp 2048 && mv -v dh.pem.tmp dh.pem
            # Ignore at this point any Dovecot master error about unknown PID
            doveadm reload
        ) &
    fi
    exec dovecot -F
else
    exec "${@}"
fi
