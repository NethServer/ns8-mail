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
        printf "%s:%s\n" "${RSPAMD_instance:?}" "${RSPAMD_adminpw:?}" >/etc/lighttpd/auth.user
        chown lighttpd /etc/lighttpd/auth.user
    )

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
