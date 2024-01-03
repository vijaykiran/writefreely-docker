
FROM alpine:3.19 as build

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories && \
    apk add --no-cache wget

RUN wget "https://github.com/writefreely/writefreely/releases/download/v0.14.0/writefreely_0.14.0_linux_amd64.tar.gz"

RUN tar xzf writefreely_0.14.0_linux_amd64.tar.gz

RUN mkdir /stage && \
    mv /writefreely /stage

FROM alpine:3.19

RUN apk add --no-cache openssl ca-certificates gcompat


COPY --from=build --chown=daemon:daemon /stage/writefreely /writefreely
COPY bin/run.sh /writefreely/

WORKDIR /writefreely
RUN ls -1 /writefreely
VOLUME /data
VOLUME /config
EXPOSE 8080
USER daemon

ENTRYPOINT ["/writefreely/run.sh"]
