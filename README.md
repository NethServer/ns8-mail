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

**Dovecot** custom configuration is saved in the `dovecot-custom` volume.
To edit it, run this command while `dovecot.service` is running:

    podman exec -ti dovecot vi /etc/dovecot/local.conf.d/myoverride.conf
    systemctl --user reload dovecot

If the service is stopped, start a dedicated container to mount the volume
properly:

    podman run --rm -ti -v dovecot-custom:/srv:z alpine vi /srv/myoverride.conf
    systemctl --user reload dovecot

For **Postfix** the commands are similar. Custom configuration is saved in
the `postfix-custom` volume. Edit it with:

    podman exec -ti postfix vi /etc/postfix/main.cf.d/myoverride.cf
    systemctl --user reload postfix

If Postfix is stopped run this one instead:

    podman run --rm -ti -v postfix-custom:/srv:z alpine vi /srv/myoverride.cf
    systemctl --user reload postfix

After applying a custom configuration, check the services are running properly:

    systemctl --user status postfix dovecot

## User impersonation

The username `vmail` is reserved and granted the *impersonate* privilege.
If the user database backend has a homonym `vmail` user, it is ignored.

Another module can obtain `vmail` credentials by invoking the action
`reveal-master-credentials`, provided it has been granted the `mailadm`
role.

## Services

1. Dovecot -- `dovecot.service`. See also dovecot/README.md
2. Postfix -- `postfix.service`. See also postfix/README.md
3. Rspamd -- N/A
4. Diffie-Hellman group generator `dhgen.service`. Starts at module boot,
   then every 15 days. See also `dhgen.timer`.

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

The tests are made using [Robot Framework](https://robotframework.org/)
