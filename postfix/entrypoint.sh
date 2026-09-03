#!/bin/ash

#
# Copyright (C) 2023 Nethesis S.r.l.
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
    if [ ! -s /etc/ssl/postfix/fullchain.pem ]; then
        (
            cd /etc/postfix
            postfix tls new-server-cert nethserver.test
            umask 077
            cat key-*.pem cert-*.pem > /etc/ssl/postfix/fullchain.pem
            rm -f key-*.pem cert-*.pem
        )
    fi
    if [ ! -s /var/spool/postfix/postsrsd/postsrsd.secret ] ; then
        (
            mkdir -vp /var/spool/postfix/postsrsd
            umask 077
            dd if=/dev/urandom bs=18 count=1 status=none | base64 > /var/spool/postfix/postsrsd/postsrsd.secret
        )
    fi
    reload-config
    # postsrsd always runs, like the Rspamd milter, regardless of
    # whether POSTFIX_SRS wires it into main.cf (NethServer/dev#7741).
    # reload-config sends it SIGHUP whenever its config changes, so it
    # only needs to be started once here. It is run as a plain direct
    # child (no -D self-daemonize) alongside Postfix, so that if either
    # one dies the other is stopped too and the whole container exits.
    /usr/sbin/postsrsd -C /etc/postsrsd/postsrsd.conf -p /run/postsrsd.pid &
    postsrsd_pid=$!

    /usr/sbin/postfix start-fg &
    postfix_pid=$!

    trap 'kill -TERM "${postfix_pid}" "${postsrsd_pid}" 2>/dev/null' TERM INT

    status=0
    wait -n || status=$?

    kill -TERM "${postfix_pid}" "${postsrsd_pid}" 2>/dev/null || true
    wait 2>/dev/null || true

    exit "${status}"
else
    exec "${@}"
fi
