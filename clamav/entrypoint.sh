#!/bin/ash

#
# Copyright (C) 2022 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# shellcheck shell=dash disable=SC3045

set -e

if [ $# -eq 0 ]; then

    if [ -z "$(ls -A1 /var/lib/clamav)" ]; then
        (   # Initialize ClamAV database
            cd /var/lib/clamav
            echo "Creating empty clamav signatures DB in /var/lib/clamav..."
            echo 'Eicar-Test-Signature:0:0:58354f2150254041505b345c505a58353428505e2937434329377d2445494341522d5354414e444152442d414e544956495255532d544553542d46494c452124482b482a' > eicar.ndb
            chown clamav:clamav eicar.ndb
        )
    fi

    # Create Clamd runtime directory
    mkdir -vp /run/clamav
    chown -c clamav:clamav /run/clamav

    # Start Clamd
    exec /usr/sbin/clamd -F <&- 2>&1
else
    exec "${@}"
fi
