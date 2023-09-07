# syntax=docker/dockerfile:1.5-labs

ARG GIT_TAG=${GIT_TAG:-master}

FROM golang:latest

ARG GIT_TAG

RUN apt-get update && \
    apt-get install -y nodejs npm 

WORKDIR /gotty
COPY . /gotty
RUN CGO_ENABLED=0 make

FROM alpine:latest

ARG UID=10001

RUN apk --update add \
        ca-certificates \
        tzdata \
        bash \
        sudo \
    && \
        update-ca-certificates \
    && \
        adduser \
            --disabled-password \
            --gecos "" \
            --home "/app" \
            --shell "/bin/bash" \
            --uid "${UID}" \
            gotty \
    && \
        echo "gotty ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY --from=0 --chmod=+x /gotty/gotty /usr/bin/

USER gotty

WORKDIR /app

EXPOSE 8080

CMD [ "gotty", "--port", "8080", "--permit-write", "--title-format", "Gotty Terminal", "bash" ]
