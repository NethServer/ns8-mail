#!/bin/bash

# Terminate on error
set -e

alpine_version=3.17.2

# Prepare variables for later use
images=()
# The image will be pushed to GitHub container registry
repobase="${REPOBASE:-ghcr.io/nethserver}"
# Configure the image name
reponame="mail"

# Create a new empty container image
container=$(buildah from scratch)

# Reuse existing nodebuilder-mail container, to speed up builds
if ! buildah containers --format "{{.ContainerName}}" | grep -q nodebuilder-mail; then
    echo "Pulling NodeJS runtime..."
    buildah from --name nodebuilder-mail -v "${PWD}:/usr/src:Z" docker.io/library/node:18.14.1-alpine
fi

if [[ -n "${SKIP_UI_BUILD}" ]]; then
    echo "SKIP_UI_BUILD is defined. Adding just an empty index.html page as UI..."
    buildah run nodebuilder-mail sh -c "cd /usr/src/ui && mkdir -p dist && touch dist/index.html"
else
    echo "Build static UI files with node..."
    buildah run \
        --workingdir=/usr/src/ui \
        --env="NODE_OPTIONS=--openssl-legacy-provider" \
        nodebuilder-mail \
        sh -c "yarn install && yarn build"
fi

# Add imageroot directory to the container image
buildah add "${container}" imageroot /imageroot
buildah add "${container}" ui/dist /ui
# Setup the entrypoint, ask to reserve one TCP port with the label and set a rootless container
buildah config --entrypoint=/ \
    --label="org.nethserver.images=$(printf "${repobase}/mail-%s:${IMAGETAG:-latest} " \
        dovecot \
        postfix \
        rspamd \
        clamav \
    )" \
    --label="org.nethserver.authorizations=node:fwadm traefik@node:fulladm" \
    "${container}"
# Commit the image
buildah commit "${container}" "${repobase}/${reponame}"
images+=("${repobase}/${reponame}")

#
# Dovecot additional image
# davidep: avoid dovecot 2.3.19-r2 - userdb lookup crashes
#
reponame="mail-dovecot"
container=$(buildah from docker.io/library/alpine:${alpine_version})
buildah run "${container}" /bin/sh <<'EOF'
set -e
addgroup -g 101 -S vmail
adduser -u 100 -G vmail -h /var/lib/vmail -S vmail
chmod -c 700 /var/lib/vmail
apk add --no-cache dovecot dovecot-ldap dovecot-pigeonhole-plugin dovecot-pop3d dovecot-lmtpd openldap-clients gettext xapian-core poppler-utils
apk add --no-cache rspamd-client
(
    # Remove the self-signed certificate
    rm -vf /etc/ssl/dovecot/server.*
    tmpdir=$(mktemp -d)
    cd "${tmpdir}"
    apk fetch --no-cache dovecot
    tar xfv dovecot-*.apk .post-install
    # Copy the post-install script to generate a new certificate from entrypoint.sh
    mv -v .post-install /usr/local/bin/dovecot-post-install
    rm -rvf "${tmpdir}"
)
(
    apk add --no-cache build-base git autoconf automake libtool dovecot-dev xapian-core-dev  icu-dev
    mkdir /tmp/build
    cd /tmp/build
    git clone https://github.com/slusarz/dovecot-fts-flatcurve.git
    cd dovecot-fts-flatcurve/
    ash autogen.sh
    ./configure --disable-static --with-dovecot=/usr/lib/dovecot/
    make
    make install
    # clean what we installed
    rm -rf /tmp/build
    apk del build-base git autoconf automake libtool xapian-core-dev dovecot-dev icu-dev
)
(
    # we build mimalloc
    apk add --no-cache git build-base cmake linux-headers
    cd /
    git clone --depth 1 https://github.com/microsoft/mimalloc
    cd mimalloc
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)
    cp *.so.* /lib
    ln -s /lib/libmimalloc.so.* /lib/libmimalloc.so || echo "Link not needed"
    # clean what we installed
    rm -rf mimalloc
    apk del git build-base cmake linux-headers
)

mkdir -p /var/lib/dovecot/dict/uquota
mkdir -p /var/lib/umail
sed -i 's/^!/#!/' /etc/dovecot/conf.d/10-auth.conf
EOF
buildah add "${container}" dovecot/ /
buildah config \
    --workingdir=/var/lib/vmail \
    --volume=/var/lib/vmail \
    --volume=/etc/ssl/dovecot \
    --volume=/var/lib/dovecot/dict \
    --volume=/var/lib/umail \
    --entrypoint='["/entrypoint.sh"]' \
    --cmd='' \
    --env=TEMPLATES_DIR="/usr/local/lib/templates" \
    --env=DOVECOT_SUBMISSION_HOST="127.0.0.1" \
    --env=DOVECOT_SUBMISSION_PORT="5587" \
    --env=DOVECOT_QUOTA_MB=0 \
    --env=DOVECOT_API_PORT=9288 \
    --env=DOVECOT_METRICS_PORT=9289 \
    --env=DOVECOT_MASTER_USERS= \
    --env=DOVECOT_DISABLED_USERS= \
    --env=DOVECOT_SPAM_RETENTION= \
    --env=DOVECOT_SPAM_FOLDER=Junk \
    --env=DOVECOT_SPAM_SUBJECT_PREFIX= \
    --env=DOVECOT_TRASH_FOLDER=Trash \
    --env=DOVECOT_MAX_USERIP_CONNECTIONS=20 \
    --env=LD_PRELOAD=/lib/libmimalloc.so \
    --env=MIMALLOC_LARGE_OS_PAGES=1 \
    "${container}"
buildah commit "${container}" "${repobase}/${reponame}"
images+=("${repobase}/${reponame}")


#
# Postfix additional image
#
reponame="mail-postfix"
container=$(buildah from docker.io/library/alpine:${alpine_version})
buildah run "${container}" /bin/sh <<EOF
set -e
apk add --no-cache postfix gettext sqlite postfix-sqlite postfix-ldap openssl
(
    mkdir -p /etc/ssl/postfix
    cd /etc/ssl/postfix
    touch server.pem server.key fullchain.pem
    chmod 600 server.key fullchain.pem
)
EOF
buildah add "${container}" postfix/ /
buildah config \
    --workingdir=/etc/postfix \
    --volume=/etc/ssl/postfix \
    --volume=/var/spool/postfix \
    --env=TEMPLATES_DIR="/usr/local/lib/templates" \
    --env=SCRIPTS_DIR="/usr/local/lib/scripts" \
    --entrypoint='["/entrypoint.sh"]' \
    --cmd='' \
    "${container}"
buildah commit "${container}" "${repobase}/${reponame}"
images+=("${repobase}/${reponame}")


#
# Rspamd additional image
#
reponame="mail-rspamd"
container=$(buildah from docker.io/library/alpine:${alpine_version})
buildah run "${container}" /bin/sh <<EOF
set -e
# Software installation order is important to preserve uid and gid allocation:
apk add --no-cache redis
apk add --no-cache rspamd rspamd-controller rspamd-proxy rspamd-fuzzy rspamd-client
apk add --no-cache unbound
chown -c root:root /etc/rspamd/local.d/maps.d
EOF
buildah add "${container}" rspamd/ /
buildah config \
    --env=RSPAMD_dkim_selector=default \
    --volume=/var/lib/redis \
    --volume=/var/lib/rspamd \
    --volume=/etc/rspamd/override.d \
    --entrypoint='["/entrypoint.sh"]' \
    --cmd='' \
    "${container}"
buildah commit "${container}" "${repobase}/${reponame}"
images+=("${repobase}/${reponame}")


#
# ClamAV additional image
#
reponame="mail-clamav"
container=$(buildah from docker.io/library/alpine:${alpine_version})
buildah run "${container}" /bin/sh <<'EOF'
set -e
apk add --no-cache ncurses bash curl wget rsync bind-tools socat gpg gpg-agent
apk add --no-cache clamav-daemon clamav-scanner 
apk add --no-cache freshclam

source_url="https://raw.githubusercontent.com/extremeshok/clamav-unofficial-sigs/7.2.5"
mkdir -vp /usr/local/sbin /etc/clamav-unofficial-sigs /var/lib/clamav-unofficial-sigs
chmod -c 750 /var/lib/clamav-unofficial-sigs
chown -c clamav:clamav /var/lib/clamav-unofficial-sigs
(
    cd /usr/local/sbin
    curl -sfL -O "${source_url}/clamav-unofficial-sigs.sh"
    chmod -c 755 clamav-unofficial-sigs.sh
)
(
    cd /etc/clamav-unofficial-sigs
    curl -sfL "${source_url}/config/master.conf" > master.conf
    curl -sfL "${source_url}/config/user.conf" > user.conf.orig
    curl -sfL "${source_url}/config/os/os.alpine.conf" > os.conf
    chmod -c 644 *.conf
    echo 'logging_enabled="no"' >> os.conf
)
EOF
buildah add "${container}" clamav/ /
buildah config \
    --entrypoint='["/entrypoint.sh"]' \
    --volume=/etc/clamav-unofficial-sigs \
    --volume=/var/lib/clamav \
    --volume=/var/lib/clamav-unofficial-sigs \
    --cmd='' \
    "${container}"
buildah commit "${container}" "${repobase}/${reponame}"
images+=("${repobase}/${reponame}")


#
# Setup CI when pushing to Github. 
# Warning! docker::// protocol expects lowercase letters (,,)
if [[ -n "${GITHUB_OUTPUT}" ]]; then
    # Set output value for Github Actions
    printf "images=%s\n" "${images[*],,}" >> "${GITHUB_OUTPUT}"
    printf " - %s:${IMAGETAG:-latest}\n" "${images[@],,}" >> $GITHUB_STEP_SUMMARY
else
    # Just print info for manual push
    printf "Publish the images with:\n\n"
    for image in "${images[@],,}"; do printf "  buildah push %s docker://%s:%s\n" "${image}" "${image}" "${IMAGETAG:-latest}" ; done
    printf "\n"
fi
