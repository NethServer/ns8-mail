# ns8-mail

NS8 Mail module with SMTP, IMAP, Spam/Virus filter

## Install

Instantiate the module with:

    add-module ghcr.io/nethserver/mail:latest

The output of the command will return the instance name.
Output example:

    {"module_id": "mail1", "image_name": "mail", "image_url": "ghcr.io/nethserver/mail:latest"}

## Configure

As an example, the following command configures a mail server
"mail.example.com" with default settings.

    api-cli run module/mail1/configure-module --data '{"hostname":"mail.example.com","user_domain":"ad.example.com","mail_domain":"example.com"}'

- Users from the domain "ad.example.com" can authenticate with SMTP
  submission, IMAP and POP services. They are offered an unlimited mailbox
  quota by default.

- The domain "example.com" is accepted as final destination with the
  default configuration for the SMTP MX server, listening on port 25.

## Custom configuration

### Dovecot custom configuration

**Dovecot** custom configuration is saved in the `dovecot-custom` volume.
To edit it, run the following commands while `dovecot.service` is running:

    # print the config values that differ from Dovecot defaults
    # WARNING! changing one of them may be dangerous!
    podman exec -ti dovecot doveconf -n
    # start the editor
    podman exec -ti dovecot vi /etc/dovecot/local.conf.d/myoverride.conf
    systemctl --user reload dovecot

If the service is stopped, start a dedicated container to mount the volume
properly:

    podman run --rm -ti -v dovecot-custom:/srv:z alpine vi /srv/myoverride.conf
    systemctl --user reload dovecot

### Postfix custom configuration

For **Postfix** the commands are similar. Custom configuration is saved in
the `postfix-custom` volume. Edit it with:

    # print the config values that differ from Postfix defaults
    # WARNING! changing one of them may be dangerous!
    podman exec -ti postfix postconf -n
    # start the editor
    podman exec -ti postfix vi /etc/postfix/main.cf.d/myoverride.cf
    systemctl --user reload postfix

If Postfix is stopped run this one instead:

    podman run --rm -ti -v postfix-custom:/srv:z alpine vi /srv/myoverride.cf
    systemctl --user reload postfix

After applying a custom configuration, check the services are running properly:

    systemctl --user status postfix dovecot

### Rspamd custom configuration

To customize the **Rspamd** configuration and to access advanced Rspamd
settings use the Rspamd web admin UI. A route matching URL path `/rspamd`
(e.g. ``https://<SERVER-FQDN/rspamd``, ``https://<SERVER-IP>/rspamd``) is
configured on Mail installation, with HTTP-Basic authentication.
Credentials valid for Cluster Admin are accepted also to access the Rspamd
UI.

As alternative, access Rspamd web UI from the local host on TCP port
11334. The web UI is internally protected by a random token that can be
obtained with

    podman exec rspamd ash -c 'echo $RSPAMD_adminpw'

Some settings cannot be controlled by the web UI. In that case, override
the Rspamd configuration by adding configuration files under
`/etc/rspamd/override.d`, which is mounted as a persistent volume. For instance run

    podman exec -ti rspamd vi /etc/rspamd/override.d/example.conf

Refer to Rspamd documentation, for the allowed file names and expected
contents.

The module self-generates a 2048-bit RSA key for DKIM at installation
time. The key is used for DKIM signing when any message is submitted by an
authenticated user, or from a local IP address.

It is possible to use a different DKIM key for a particular domain by
applying the following procedure. Given the DNS TXT record is be selected
by `myselector`,

1. open an interactive shell in the Rspamd running container:

       podman exec -ti rspamd ash

1. generate a new key, with the wanted selector:

       rspamadm dkim_keygen -s myselector -b 2048 -k /var/lib/rspamd/dkim/myselector.key > /var/lib/rspamd/dkim/myselector.txt
       chgrp rspamd /var/lib/rspamd/dkim/myselector.key

2. access the Rspamd admin UI, and edit
   `/var/lib/rspamd/dkim_selectors.map`. Add a line like

       mydomain.example.com myselector

3. add a DNS TXT record to `mydomain.example.com`, as described in
   `/var/lib/rspamd/dkim/myselector.txt`

## Configuration override for ClamAV unofficial signatures

Changes to `clamav-unofficial-sigs` configuration are volatile. When the
`clamav` container is stopped, local configuration changes are lost.

To manage a persistent and custom `clamav-unofficial-sigs` configuration:

1. Edit the `state/environment` file and set the following variable

       CLAMAV_CUSCFG_VOLUME_FLAGS=Z

1. Restart the clamav container. The configuration is now mounted on a persistent volume, `clamav-cus-cfg`:

       systemctl --user restart clamav

1. Edit `/etc/clamav-unofficial-sigs/user.conf` as wanted:

       podman exec -ti clamav vi /etc/clamav-unofficial-sigs/user.conf

To switch back to the volatile configuration

1. Edit the variable line in `state/environment` (or remove it completely):

       CLAMAV_CUSCFG_VOLUME_FLAGS=O

1. Stop the clamav service

1. Remove the custom changes:

       podman volume rm clamav-cus-cfg

1. Start the clamav service

Either in persistent or volatile mode, changes to the configuration are
picked up on the next `clamav-unofficial-sigs.timer` run.

To forcibly download new signatures, run:

    podman exec clamav download-sigs cus -F

## User impersonation

The username `vmail` is reserved and granted the *impersonate* privilege.
If the user database backend has a homonym `vmail` user, it is ignored.

Another module can obtain `vmail` credentials by invoking the action
`reveal-master-credentials`, provided it has been granted the `mailadm`
role.

## Public mailboxes

Subfolders of Vmail's INBOX are visible to all users under the Public
namespace.  Vmail's INBOX is initialized with a special `lookup`
permission granted to all authenticated users. To reset it run this
command:

    podman exec dovecot doveadm acl set -u vmail INBOX authenticated lookup

## Services

1. Dovecot -- `dovecot.service`. See also dovecot/README.md
2. Postfix -- `postfix.service`. See also postfix/README.md
3. Rspamd -- `rspamd.service`. See also rspamd/README.md
4. Diffie-Hellman group generator `dhgen.service`. Starts at module boot,
   then every 15 days. See also `dhgen.timer`.
5. Freshclam signatures download -- `freshclam.service` (with timer)
6. ClamAV unofficial signatures download -- `clamav-unofficial-sigs.service` (with timer)

## Rspamd admin UI

To access the admin web UI of Rspamd point the browser to

    https://<mail host>/rspamd/

## Rspamd bulk Bayesian filter training

To efficiently train the Rspamd Bayesian filter plugin in an NS8
environment, use the `rspamc` wrapper command, which incorporates Rspamd's
authentication header logic.

To display the help output for the `rspamc-wrapper` command, run:

    # Display the help output for rspamc-wrapper
    runagent -m mail1 podman exec -i dovecot rspamc-wrapper --help

To train the filter with ham messages, specify the mailbox path relative
to Dovecot's working directory. For example, to train with messages from
`first.user`'s mailbox:

    # Read ham messages from an existing Maildir in the container
    runagent -m mail1 podman exec -i dovecot rspamc-wrapper learn_ham first.user/Maildir/cur

For a single spam file (e.g., in mbox format), use shell redirection to
pass the file through stdin. For example:

    # Train filter with spam messages in a single mbox file
    runagent -m mail1 podman exec -i dovecot rspamc-wrapper learn_spam < spamarchive.mbox

If you have multiple spam files in a directory on the host, copy them into
the container's filesystem using:

    # Copy directory and its contents into Dovecot's container, under /srv
    tar -c ./some-spamdir | runagent -m mail1 podman cp - dovecot:/srv

Note that `/srv/some-spamdir` is not mounted to a persistent volume, so
its contents are volatile and will be lost on the next container restart.
To train with messages from the container directory, run:

    # Train filter with spam messages in the volatile destination directory
    runagent -m mail1 podman exec -i dovecot rspamc-wrapper learn_spam /srv/some-spamdir

For best results, verify successful training by reviewing the Rspamd logs
or using diagnostic commands. Consult the Rspamd documentation for further
details.

## Service discovery

Another module can discover IMAP and SUBMISSION endpoints by looking up
the following Redis key pattern:

- `KEYS module/mail[1-9]*/srv/tcp/imap`
- `KEYS module/mail[1-9]*/srv/tcp/submission`

Returned key type is HASH, with the the following items:

| key    | value example   | description |
| ------ | --------------- | ----------- |
| `host` | 10.5.4.1        |             |
| `port` | 143             | for IMAP    |
| `node` | 1               | the node identifier where the service is located |
| `user_domain` | nethserver.test | name of user domain (LDAP protocol only)  |
| `uuid` | 35457a5f-b0c1-421f-86f3-81df090df818 | module instance universal identifier |

When settings change, the `mail-settings-changed` event is published. Payload format is

```json
{
  "reason": "configure-module",
  "module_id": "mail1",
  "module_uuid": "35457a5f-b0c1-421f-86f3-81df090df818",
  "node_id": 1
}
```

The event reason reflects the action name that raises the event.

## Commands

- `install-certificate` installs the TLS certificate and DH group in the
  given service container.

## Uninstall

To uninstall the instance:

    remove-module --no-preserve mail1

## Testing

Test the module using the `test-module.sh` script:

    ./test-module.sh <NODE_ADDR> ghcr.io/nethserver/mail:latest

Additional arguments are forwarded to the `robot` command (see [Robot
Framework](https://robotframework.org/)).

For instance, to speed up testing on a local machine:

1. skip the account provider removal

       SSH_KEYFILE=~/.ssh/id_ecdsa bash test-module.sh 10.5.4.1 ghcr.io/nethserver/mail:mail-rspamd --exclude udomANDremove

2. since then, skip also installation

       SSH_KEYFILE=~/.ssh/id_ecdsa bash test-module.sh 10.5.4.1 ghcr.io/nethserver/mail:mail-rspamd --exclude udom

## Migration from nethserver-mail (NS7)

The NS7 migration tool (`nethserver-ns8-migration` RPM) transfers the
Email app configuration and mailboxes data. It invokes the `import-module`
action, which implements the conversion procedure from NS7 to NS8 format.

Migration notes:

1. SMTP/IMAP user name. Any `@domain` suffix is ignored, only the user
   name is considered.

1. Mail storage. The user `@domain` suffix was removed in NS8. Mailbox
   paths are renamed from the old `user@domain` form to new `user`. ACLs
   and shared-mailboxes.db files are fixed accordingly.

1. "Full control" ACLs now includes the "delete" permission. Granted ACLs
   are upgraded as necessary.

1. `root` user. Even if in NS8 a **root user does not exist**, its mailbox
   contents are transferred. For additional security the `root` mailbox is
   marked "disabled" in `DOVECOT_DISABLED_USERS`. It is possible to access
   its contents by either configuring it as shared, or by creating a
   "root" user in the LDAP database with a new, secure password.

1. Quota temporarily unavailable. The new "quota count" Dovecot backend is
   used. Large mailboxes need a while to reindex the quota size. During
   reindexing, quota information is not available and the following
   message is logged:

       quota-count: Ongoing quota calculation blocked

1. Filter settings are migrated. Filter bypass rules and Postfix
   `mynetworks` setting are converted and imported from the following
   e-smith DB props: `postfix/AccessBypassList`, `rspamd/SenderWhiteList`,
   `rspamd/RecipientWhiteList`.

1. New Full Text Search (FTS) engine Flatcurve. Old FTS indexes are
   excluded from the migration. Refer to **Full Text Searche (FTS)**
   section below.

## Full Text Search (FTS)

The default configuration enables full-text search over mail headers and
body. To keep the FTS index size small, only exact-word tokens are indexed
by default.

To enable complete substring searches, the indexes must be rebuilt, which
significantly increases disk space usage.

### Enable FTS substring search

It is advisable to run this procedure outside of working hours because
mailbox reindexing has high system resource demands.

Edit the module's `state/environment` file by adding the following line:

    DOVECOT_FLATCURVE_SUBSTRING_SEARCH=yes

Reload the Dovecot container:

    systemctl --user reload dovecot

Open a shell in the Dovecot container:

    podman exec -ti dovecot ash -l

Calculate the size of the current FTS indexes (in MB):

    find . -type d -name fts-flatcurve -print0 | xargs -r -0 -- du -m | awk '{ tot += $1 } ; END { print tot }'

Remove existing `fts-flatcurve` directories:

    find . -type d -name fts-flatcurve -exec rm -rf '{}' \;

To rebuild the search indexes in bulk, run the following command during
system idle time:

    nice doveadm index -A -q '*'

## UI translation

Translated with [Weblate](https://hosted.weblate.org/projects/ns8/).

To setup the translation process:

- add [GitHub Weblate app](https://docs.weblate.org/en/latest/admin/continuous.html#github-setup) to your repository
- add your repository to [hosted.weblate.org](https://hosted.weblate.org) or ask a NethServer developer to add it to ns8 Weblate project
