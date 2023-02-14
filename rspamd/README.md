# mail-rspamd

This container runs Rspamd with the required Redis backends for volatile
and non-volatile data storage.

The web API service provided by the Rspamd controller process runs behind
a Lighttpd HTTP reverse proxy, that is responsible for user
authentication.

Access to web UI and API on

    http://127.0.0.1:11334

See `RSPAMD_adminpw` for the password of user `admin`.

## TCP ports

Well-known ports

- 11332 proxy worker (milter)
- 11333 normal worker (scanner)
- 11334 controller worker (behind Lighttpd HTTP proxy)
- 11335 fuzzy worker
- 11336 unbound (recursive, caching DNS resolver)

## Environment variables

- `RSPAMD_instance` Rspamd instance name, required for syslog identity
  field and used for authentication on the controller HTTP service
- `RSPAMD_adminpw` Password of user `admin` on HTTP port 11334
- `RSPAMD_spamtpw` Password of user `spamt`, used to access spam training
  endpoints on HTTP port 11334
- `RSPAMD_dkim_selector` The name of the default DKIM selector; the
  default value is `default`, which is compatible with NS7 to ease the
  migration of existing mail servers.
- `RSPAMD_clamav_endpoint` The `IP:port` address of a ClamAV instance.
  Empty string disables the AV check completely.

## Volumes

- `/etc/rspamd/override.d` Rspamd custom configuration
- `/var/lib/rspamd` Rspamd persistent storage
- `/var/lib/redis` Redis persistent storage

## Commands

- `reload-config` Send an HUP signal to Rspamd
- `rspamc` invoke with the following arguments to scan a mail message from stdin:

      rspamc -h 127.0.0.1:11333 -P $RSPAMD_adminpw
