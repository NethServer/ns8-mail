# mail-clamav

ClamAV container for anti-virus mail checks. Both official and
non-official signature databases are stored in persistent volumes.

## TCP ports

Well-known ports

- ClamAV - clamd 11330

## Environment variables

- `CLAMAV_CUS_RATING` Value for clamav-unofficial-sigs parameter
  `default_dbs_rating`. Value must be one of `LOW`, `MEDIUM` (the
  default), `HIGH`, `DISABLE`. See official documentation for the meaning
  of those values. The default value is highly recommended.

## Volumes

- `/var/lib/clamav` ClamAV signature DB
- `/var/lib/clamav-unofficial-sigs` Signatures cache, fetched by
  [clamav-unofficial-sigs.sh](https://github.com/extremeshok/clamav-unofficial-sigs),
  _CUS_ in short
- `/etc/clamav-unofficial-sigs` Configuration files. This volume can be
  mounted with overlay "O" flag, that means any change to its contents are
  temporary, thus they are lost when the container is stopped. Note that
  in any case, `user.conf` is modified by the `set-cus-rating` command.

## Commands

- `download-sigs` Download signatures with one of the available methods:
     1. `cus` (clamav-unofficial-sigs)
     2. `freshclam` (Freshclam)

  Method name is passed as first command argument. Additional arguments are passed to the downloader executable.

- `set-cus-rating` This command sets the value of `default_dbs_rating` in
  the `user.conf` file. Pass the value (e.g. `LOW`) as the first argument
  to the command.
