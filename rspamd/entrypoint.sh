#!/bin/ash

#
# Copyright (C) 2022 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# shellcheck shell=dash disable=SC3045

set -e

if [ $# -eq 0 ]; then

    (   # Store Rspamd admin UI credentials for Lighttpd
        umask 027
        printf "%s:%s\n" "admin" "${RSPAMD_adminpw:?}" >/etc/lighttpd/auth.user
        chown lighttpd /etc/lighttpd/auth.user
    )

    # Create path for DKIM keys
    dkim_dir="/var/lib/rspamd/dkim"
    if [ ! -d "${dkim_dir}" ]; then
        mkdir -v -m 0750 "${dkim_dir}"
        echo "Generating DKIM signing key. Add the following TXT record to DNS domains:"
        rspamadm dkim_keygen -s "${RSPAMD_dkim_selector:?}" -b 2048 -k "${dkim_dir}/${RSPAMD_dkim_selector}.key" | tee "${dkim_dir}/${RSPAMD_dkim_selector}.txt"
        chgrp -cR rspamd "${dkim_dir}"
    fi

    su -s /bin/ash - redis -c "exec /usr/bin/redis-server /etc/redis-persistent.conf --syslog-ident ${RSPAMD_instance}/redis-persistent" </dev/null &
    su -s /bin/ash - redis -c "exec /usr/bin/redis-server /etc/redis-volatile.conf --syslog-ident ${RSPAMD_instance}/redis-volatile" </dev/null &

    (   # Start Rspamd with syslog redirects
        /usr/sbin/rspamd -u rspamd -g rspamd -f <&- 2>&1 | \
        logger -t "${RSPAMD_instance:?}/rspamd" -p MAIL.INFO
    ) &
    (   # Start Lighttpd with syslog redirects
        /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf <&- 2>&1 3>&1 | \
        logger -t "${RSPAMD_instance:?}/lighttpd" -p DAEMON.INFO
    ) &

    wait -n
    exit $?
else
    exec "${@}"
fi
