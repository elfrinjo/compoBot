FROM alpine:latest

LABEL maintainer "J. Elfring <code@elfring.ms>"
LABEL org.opencontainers.image.source https://github.com/elfrinjo/compoBot

RUN apk --no-cache --update \
        add ca-certificates \
            coreutils \
            bash \
            curl \
            sed \
            sqlite \
    && mkdir /app \
    && mkdir /data

COPY . /app/

ENV database=/data/compobot.db3 \
    minWait=43200 \
    maxWait=86400 \
    mtdVisibility=direct \
    mtdApi=https://mastodon.example/api/v1/statuses \
    mtdToken=INSERT-YOUR-BEARER-TOKEN

VOLUME /data
WORKDIR /app
CMD ["/app/compoBot.sh"]
