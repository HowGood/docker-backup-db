FROM alpine:latest

RUN apk add --no-cache \
      bash \
      curl \
      gnupg \
      gzip \
      postgresql-client \
      python3 \
      py3-pip \
    && python3 -m pip install -U --no-cache-dir pip \
    && python3 -m pip install -U --no-cache-dir awscli

COPY ./backup.sh /usr/local/bin/backup.sh
COPY ./download-backup.sh /usr/local/bin/download-backup.sh

RUN chmod 755 /usr/local/bin/backup.sh \
    && chmod 755 /usr/local/bin/download-backup.sh

RUN mkdir -p /backup/
WORKDIR /backup/

CMD /usr/local/bin/backup.sh
