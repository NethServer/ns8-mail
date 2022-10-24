# mail-clamav

ClamAV container for anti-virus mail checks. Both official and
non-official signature databases are stored in persistent volumes.

## TCP ports

Well-known ports

- ClamAV - clamd 11330

## Environment variables

None

## Volumes

- `/var/lib/clamav` ClamAV signature DB
- `/var/lib/clamav-unofficial-sigs` Signatures cache, fetched by [clamav-unofficial-sigs.sh](https://github.com/extremeshok/clamav-unofficial-sigs), _CUS_ in short
- `/etc/clamav-unofficial-sigs/override.d` Override clamav-unofficial-sigs
  configuration. Put a `user.conf` file in it, and the default one is
  completely overwritten.

## Commands

- `download-sigs` Download signatures with one of the available methods:
     1. `cus` (clamav-unofficial-sigs)
     2. `freshclam` (Freshclam)

  Method name is passed as first command argument. Additional arguments are passed to the downloader executable.
