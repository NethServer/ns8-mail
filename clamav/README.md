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
- `/var/lib/clamav-unofficial-sigs` Signatures cache, fetched by
  [clamav-unofficial-sigs.sh](https://github.com/extremeshok/clamav-unofficial-sigs),
  _CUS_ in short
- `/etc/clamav-unofficial-sigs` Configuration files. This volume can be
  mounted with overlay "O" flag, that means any change to its contents are
  temporary, thus they are lost when the container is stopped. Note that
  in any case, `user.conf` is modified by the `set-cus-rating` command.

## Commands

- `download-sigs` Download signatures with one of the available methods:
     1. `cus`, `cus-low`, `cus-medium`, `cus-high`, `cus-disable`
        (clamav-unofficial-sigs)
     2. `freshclam` (Freshclam)

  Method name is passed as first command argument. Additional arguments
  are passed to the downloader executable. The `cus-*` variants implicitly
  invoke `set-cus-rating` before the download starts to adjust the rating
  configuration.

- `set-cus-rating` This command sets the value of `default_dbs_rating` in
  the `user.conf` file. Pass the value (e.g. `LOW`, `MEDIUM`, `HIGH` or
  `DISABLE`) as the first argument to the command. See the
  clamav-unofficial-sigs documentation for the meaning of those values;
  `MEDIUM` is the recommended default.
