#!/bin/bash
#
# Copyright (C) 2026 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Keeps a shallow clone of ns8-github-actions in ~/.cache and delegates
# to its test-module.sh.
#
# Usage (from the module repo root):
#   ./test-module.sh <LEADER_NODE> <IMAGE_URL> [extra robot args...]
#   RUN_UI_TESTS=true SSH_KEYFILE=~/.ssh/id_ecdsa ./test-module.sh <LEADER_NODE> <IMAGE_URL> [extra robot args...]
#
# Environment variables forwarded to test-module.sh:
#   RUN_UI_TESTS    set to "true" to enable browser/UI tests (default: off)
#   SSH_KEYFILE     path to SSH private key (default: ~/.ssh/id_ecdsa)
#

set -e

CACHE_DIR="${HOME}/.cache/ns8-github-actions"
REPO_URL="https://github.com/nethserver/ns8-github-actions.git"

if [ -d "${CACHE_DIR}/.git" ]; then
    # fetch+reset is more reliable than pull for shallow clones:
    # pull can fail if the remote was force-pushed or history diverged.
    # On network failure, fall back to the cached version with a warning.
    git -C "${CACHE_DIR}" fetch --depth=1 -q origin \
        && git -C "${CACHE_DIR}" reset --hard -q FETCH_HEAD \
        || echo "Warning: could not update ns8-github-actions, using cached version" >&2
else
    # Remove any incomplete or corrupt directory before cloning.
    # git clone refuses to write into a non-empty directory.
    rm -rf "${CACHE_DIR}"
    # git clone --depth=1 -q "${REPO_URL}" "${CACHE_DIR}" //// uncomment
    git clone --depth=1 -q -b refactor-testing "${REPO_URL}" "${CACHE_DIR}"
fi

exec "${CACHE_DIR}/scripts/test-module.sh" "$@"
