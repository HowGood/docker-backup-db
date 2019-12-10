#!/usr/bin/env bash
##
# Restore an RDS Postgres database from S3
#
# Environment variables to set:
#   - PGHOST
#   - PGPORT
#   - PGUSER
#   - PGPASSWORD
#   - S3_BUCKET
#   - GPG_PASSPHRASE
#
# Arguments
#   $1 => The path to the gpg file inside the S3 bucket to restore.
#         eg: 2020/01/01/howgood.2020-01-01.010203.psql.gpg
##

set -e


GPG_FILEPATH="$1"
GPG_FILENAME="$(basename "${GPG_FILEPATH}")"
SQL_FILENAME="${GPG_FILENAME//.gpg/}"


(
  set -x
  aws s3 cp "s3://${S3_BUCKET}/${GPG_FILEPATH}" .
)

(
  set -x
  gpg --batch --yes --passphrase="$GPG_PASSPHRASE" -d "$GPG_FILENAME" \
    > "$SQL_FILENAME"
)
