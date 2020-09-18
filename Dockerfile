FROM alpine:latest

LABEL maintainer "J. Elfring <code@elfring.ms>"

RUN apk --no-cache --update \
        add bash \
            ca-certificates \
            curl \
            sqlite \
        && mkdir -p /app/sequences \
        && mkdir /data

COPY sequences/Compose.db3 /app/sequences/Compose.db3
COPY compoBot.sh /app/compoBot.sh

ENV database="/data/working-db.db3" \
    minWait=43200 \
    maxWait=86400 \
    mtdApi="https://mastodon.example/api/v1/statuses" \
    mtdVisibility="direct" \
    mtdToken="THIS_SHOULD_BE_A_Bearer-Token" \

VOLUME /data
WORKDIR /app
CMD ["/app/compoBot.sh"]
