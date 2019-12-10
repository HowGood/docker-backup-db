#!/usr/bin/env bash
##
# Backup an RDS Postgres database to S3
#
# Environment variables to set:
#   - PGHOST
#   - PGPORT
#   - PGUSER
#   - PGPASSWORD
#   - S3_BUCKET
#   - GPG_PASSPHRASE
##

set -e


BACKUP_FILENAME="${PGDATABASE}.$(date '+%Y-%m-%d.%H%M%S').psql"
BACKUP_FILEPATH="/backup/${BACKUP_FILENAME}"

S3_BACKUP_FOLDER="s3://${S3_BUCKET}/$(date '+%Y/%m/%d')/"


echo "Starting backup of ${PGDATABASE}"
(
  set -x
  pg_dump --no-owner \
          --schema=public \
          --format=c \
          --compress=9 \
          --file="$BACKUP_FILEPATH" \
          "$PGDATABASE"
)

echo "Encrypting $BACKUP_FILEPATH"
(
  set -x
  gpg --yes --batch --passphrase="$GPG_PASSPHRASE" -c "$BACKUP_FILEPATH"
)

echo "Uploading ${BACKUP_FILEPATH}.gpg to ${S3_BACKUP_FOLDER}"
(
  set -x
  aws s3 cp "${BACKUP_FILEPATH}.gpg" "${S3_BACKUP_FOLDER}"
)

echo "Completed backup of ${PGDATABASE} to ${S3_BACKUP_FOLDER}"
