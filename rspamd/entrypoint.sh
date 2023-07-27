#!/bin/ash

#
# Copyright (C) 2023 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# shellcheck shell=dash disable=SC3045

set -e

if [ $# -eq 0 ]; then

    reload-config

    # Create path for DKIM keys
    dkim_dir="/var/lib/rspamd/dkim"
    if [ ! -d "${dkim_dir}" ]; then
        mkdir -v -m 0750 "${dkim_dir}"
        echo "Generating DKIM signing key. Add the following TXT record to DNS domains:"
        rspamadm dkim_keygen -s "${RSPAMD_dkim_selector:?}" -b 2048 -k "${dkim_dir}/${RSPAMD_dkim_selector}.key" | tee "${dkim_dir}/${RSPAMD_dkim_selector}.txt"
        chgrp -cR rspamd "${dkim_dir}"
    fi

    su -s /bin/ash - redis -c "exec /usr/bin/redis-server /etc/redis-persistent.conf" </dev/null &
    su -s /bin/ash - redis -c "exec /usr/bin/redis-server /etc/redis-volatile.conf" </dev/null &

    # Start local Unbound DNS server (UDP port 11336)
    /usr/sbin/unbound-anchor -v || :
    /usr/sbin/unbound -d <&- &

    # Start rspamd
    mkdir -v -m 0750 -p /run/rspamd
    chown -c rspamd:rspamd /run/rspamd
    /usr/sbin/rspamd -u rspamd -g rspamd -f <&- &

    wait -n
    exit $?
else
    exec "${@}"
fi
