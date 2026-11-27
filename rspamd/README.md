# mail-rspamd

This container runs Rspamd with the required Redis backends for volatile
and non-volatile data storage.

Access to web UI and API on

    http://127.0.0.1:11334

See `RSPAMD_adminpw` and `RSPAMD_basicpw` for the required passwords.

## TCP ports

Well-known ports

- 11332 proxy worker (milter)
- 11333 normal worker (scanner)
- 11334 controller worker
- 11335 fuzzy worker
- 11336 unbound (recursive, caching DNS resolver)

## Environment variables

- `RSPAMD_adminpw` Token for accessing Rspamd controller
- `RSPAMD_dkim_selector` The name of the default DKIM selector; the
  default value is `default`, which is compatible with NS7 to ease the
  migration of existing mail servers.
- `RSPAMD_clamav_endpoint` The `IP:port` address of a ClamAV instance.
  Empty string disables the AV check completely.
- `RSPAMD_antispam_checks_enabled` Empty string means "disabled": in this
  case Rspamd runs only DKIM signatures and AV checks. Other string values
  is "enabled": Rspamd runs also anti-spam checks.
- `RSPAMD_greylist_enabled` Empty string means greylist is disabled. Other
  string values enable the greylist feature.
- `RSPAMD_bypass_score` If undefined (default) bypass rules are applied as
  an accept prefilter. Set to a negative number to turn the rules to ham
  score and run antivirus checks (e.g. `RSPAMD_bypass_score=-5.000`)
- `RSPAMD_block_score` If undefined (default) block rules are applied as
  an reject prefilter. Set to a number to turn the rules to spam score and 
  run antivirus checks (e.g. `RSPAMD_block_score=20`)
- `RSPAMD_clamavscansize` sets the maximum size (default 2 MB) for
  email attachments scanned by ClamAV in Rspamd.
  Attachments larger than this value are skipped to optimize performance.
- `RSPAMD_RL_HOURLY` enables the outbound rate limit for authenticated
  users: maximum number of messages per hour, per user, with a burst of
  `RSPAMD_RL_HOURLY / 12` messages. If it is not set, empty, `0`, a
  negative number, or not a number, the rate limit is off.
- `RSPAMD_RL_BULK_HOURLY` maximum number of messages per hour for users
  listed in `/var/lib/rspamd/ratelimit_bulk.map`. If it is not a positive
  number, the default is 10 times `RSPAMD_RL_HOURLY`.

## Volumes

- `/etc/rspamd/override.d` Rspamd custom configuration
- `/var/lib/rspamd` Rspamd persistent storage
- `/var/lib/redis` Redis persistent storage

## Commands

- `reload-config` Send an HUP signal to Rspamd
- `rspamc` invoke with the following arguments to scan a mail message from stdin:

      rspamc -h 127.0.0.1:11333 --password="$RSPAMD_adminpw"
