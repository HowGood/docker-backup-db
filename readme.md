# Backup Database Container

This contains the scripts for backing up and restoring a Postgres database using `gpg` to encrypt it, and AWS S3 for storage.

## Usage

To create a database backup, supply the required environment variables and execute the docker image.

```bash
docker run --rm -it \
           -e PGHOST=localhost \
           -e PGPORT=5432 \
           -e PGUSER=postgres \
           -e PGPASSWORD=s3cr3t_p4ssw0rd \
           -e S3_BUCKET=backups.example.com \
           -e GPG_PASSPHRASE=p4ssw0rd \
           howgood/backup-db:latest
```

To download and decrypt a database backup, supply the required environment variables again, and execute the docker image with the restore script as the command.

```bash
docker run --rm -it \
           -e PGHOST=localhost \
           -e PGPORT=5432 \
           -e PGUSER=postgres \
           -e PGPASSWORD=s3cr3t_p4ssw0rd \
           -e S3_BUCKET=backups.example.com \
           -e GPG_PASSPHRASE=p4ssw0rd \
           -v "$(pwd):/backup/" \
           howgood/backup-db:latest \
           /usr/local/bin/download-backup.sh
```
