# mail-rspamd

This container runs Rspamd with the required Redis backends for volatile
and non-volatile data storage.

## TCP ports

Well-known ports

- 11332 proxy worker (milter)
- 11333 normal worker (scanner)
- 11334 controller worker
- 11335 fuzzy worker

## Environment variables

- `RSPAMD_instance` Rspamd instance name, required for syslog identity field

## Volumes

- `/var/lib/rspamd` Rspamd persistent storage
- `/var/lib/redis` Redis persistent storage

## Commands

- `reload-config` Send an HUP signal to Rspamd
