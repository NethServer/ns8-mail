# mail-rspamd

This container runs Rspamd with the required Redis backends for volatile
and non-volatile data storage.

The web API service provided by the Rspamd controller process runs behind
a Lighttpd HTTP reverse proxy, that is responsible for user
authentication.

## TCP ports

Well-known ports

- 11332 proxy worker (milter)
- 11333 normal worker (scanner)
- 11334 controller worker (behind Lighttpd HTTP proxy)
- 11335 fuzzy worker

## Environment variables

- `RSPAMD_instance` Rspamd instance name, required for syslog identity
  field and used for authentication on the controller HTTP service
- `RSPAMD_adminpw` Password for the HTTP service

## Volumes

- `/var/lib/rspamd` Rspamd persistent storage
- `/var/lib/redis` Redis persistent storage

## Commands

- `reload-config` Send an HUP signal to Rspamd
