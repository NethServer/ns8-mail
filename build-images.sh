#!/bin/bash

# Terminate on error
set -e

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
    buildah from --name nodebuilder-mail -v "${PWD}:/usr/src:Z" docker.io/library/node:lts
fi

if [[ -n "${SKIP_UI_BUILD}" ]]; then
    echo "SKIP_UI_BUILD is defined. Adding just an empty index.html page as UI..."
    buildah run nodebuilder-mail sh -c "cd /usr/src/ui && mkdir -p dist && touch dist/index.html"
else
    echo "Build static UI files with node..."
    buildah run nodebuilder-mail sh -c "cd /usr/src/ui && yarn install && yarn build"
fi

# Add imageroot directory to the container image
buildah add "${container}" imageroot /imageroot
buildah add "${container}" ui/dist /ui
# Setup the entrypoint, ask to reserve one TCP port with the label and set a rootless container
buildah config --entrypoint=/ \
    --label="org.nethserver.images=${repobase}/mail-dovecot:${IMAGETAG:-latest} ${repobase}/mail-postfix:${IMAGETAG:-latest}" \
    --label="org.nethserver.authorizations=node:fwadm traefik@node:certadm" \
    "${container}"
# Commit the image
buildah commit "${container}" "${repobase}/${reponame}"
images+=("${repobase}/${reponame}")

#
# Dovecot additional image
# davidep: avoid dovecot 2.3.19-r2 - userdb lookup crashes
#
reponame="mail-dovecot"
container=$(buildah from docker.io/library/alpine:3.15)
buildah run "${container}" /bin/sh <<'EOF'
set -e
addgroup -g 101 -S vmail
adduser -u 100 -G vmail -h /var/lib/vmail -S vmail
chmod -c 700 /var/lib/vmail
apk add --no-cache dovecot dovecot-ldap dovecot-pigeonhole-plugin dovecot-pop3d dovecot-lmtpd openldap-clients gettext
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
    "${container}"
buildah commit "${container}" "${repobase}/${reponame}"
images+=("${repobase}/${reponame}")


#
# Postfix additional image
#
reponame="mail-postfix"
container=$(buildah from docker.io/library/alpine:3.15)
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
# Setup CI when pushing to Github. 
# Warning! docker::// protocol expects lowercase letters (,,)
if [[ -n "${CI}" ]]; then
    # Set output value for Github Actions
    printf "::set-output name=images::%s\n" "${images[*],,}"
else
    # Just print info for manual push
    printf "Publish the images with:\n\n"
    for image in "${images[@],,}"; do printf "  buildah push %s docker://%s:%s\n" "${image}" "${image}" "${IMAGETAG:-latest}" ; done
    printf "\n"
fi
