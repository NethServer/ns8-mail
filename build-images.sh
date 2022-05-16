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

# # Reuse existing nodebuilder-mail container, to speed up builds
# if ! buildah containers --format "{{.ContainerName}}" | grep -q nodebuilder-mail; then
#     echo "Pulling NodeJS runtime..."
#     buildah from --name nodebuilder-mail -v "${PWD}:/usr/src:Z" docker.io/library/node:lts
# fi

# echo "Build static UI files with node..."
# buildah run nodebuilder-mail sh -c "cd /usr/src/ui && yarn install && yarn build"
mkdir -p ui/dist
touch ui/dist/index.html

# Add imageroot directory to the container image
buildah add "${container}" imageroot /imageroot
buildah add "${container}" ui/dist /ui
# Setup the entrypoint, ask to reserve one TCP port with the label and set a rootless container
buildah config --entrypoint=/ \
    --label="org.nethserver.images=${repobase}/mail-dovecot:${IMAGETAG:-latest}" \
    --label="org.nethserver.authorizations=node:fwadm" \
    "${container}"
# Commit the image
buildah commit "${container}" "${repobase}/${reponame}"

# Append the image URL to the images array
images+=("${repobase}/${reponame}")

#
# Dovecot additional image
#
reponame="mail-dovecot"
container=$(buildah from docker.io/library/alpine:3)
buildah run "${container}" /bin/sh <<EOF
addgroup -g 101 -S vmail
adduser -u 100 -G vmail -h /var/lib/vmail -S vmail
apk add --no-cache dovecot dovecot-ldap dovecot-pigeonhole-plugin dovecot-submissiond dovecot-pop3d dovecot-lmtpd gettext
EOF
buildah add "${container}" dovecot/ /
buildah config \
    --workingdir=/var/lib/vmail \
    --volume=/var/lib/vmail \
    --entrypoint='["/entrypoint.sh"]' \
    --cmd='' \
    --env=TEMPLATES_DIR="/usr/local/lib/templates" \
    --env=DOVECOT_SUBMISSION_HOST="127.0.0.1" \
    --env=DOVECOT_SUBMISSION_PORT="5587" \
    "${container}"
buildah commit "${container}" "${repobase}/${reponame}"

# Append the image URL to the images array
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
