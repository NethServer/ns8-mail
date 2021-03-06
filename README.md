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

    api-cli run module/mail1/configure-module --data '{"hostname":"mail.example.com","user_domain":"ad.example.com","mailbox_quota_mb":200,"mail_domain":"example.com"}'

- Users from the domain "ad.example.com" can authenticate with SMTP
  submission, IMAP and POP services. They are offered a mailbox quota of
  200 MB.

- The domain "example.com" is accepted as final destination with the
  default configuration for the SMTP MX server, listening on port 25.

## Services

1. Dovecot -- `dovecot.service`. See also dovecot/README.md
2. Postfix -- `postfix.service`. See also postfix/README.md
3. Rspamd -- N/A
4. Diffie-Hellman group generator `dhgen.service`. Starts at module boot,
   then every 15 days. See also `dhgen.timer`.

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
