#!/bin/ash

#
# Copyright (C) 2022 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# shellcheck shell=dash disable=SC3045

set -e

if [ $# -eq 0 ]; then

    # Forward rspamd "console" log type to logger, to set syslog ident as
    # wanted because Rspamd has an hardcoded ident ("rspamd").
    plog=$(mktemp -u /tmp/logger.XXXXXX)
    mkfifo "${plog}"
    logger -t "${RSPAMD_instance:?}/rspamd" -p MAIL.INFO <"${plog}" &
    exec >>"${plog}"
    rm -f "${plog}"

    su -s /bin/ash - redis -c "exec /usr/bin/redis-server /etc/redis-persistent.conf --syslog-ident ${RSPAMD_instance}/redis-persistent" </dev/null &
    su -s /bin/ash - redis -c "exec /usr/bin/redis-server /etc/redis-volatile.conf --syslog-ident ${RSPAMD_instance}/redis-volatile" </dev/null &
    /usr/sbin/rspamd -u rspamd -g rspamd -f </dev/null 2>&1 &

    wait -n
    exit $?
else
    exec "${@}"
fi
