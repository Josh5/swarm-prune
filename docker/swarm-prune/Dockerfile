FROM docker:latest

RUN apk add --no-cache bash busybox-suid

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY cleanup.sh /usr/local/bin/cleanup.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
