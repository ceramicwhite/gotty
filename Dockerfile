FROM golang:latest

RUN apt-get update && \
    apt-get install -y nodejs npm

WORKDIR /gotty
COPY . /gotty
RUN CGO_ENABLED=0 make

FROM alpine:latest

RUN apk --update add \
        ca-certificates \
        tzdata \
        bash \
    && \
        update-ca-certificates \
    && \
        apk add --upgrade bash

WORKDIR /root

COPY --from=0 --chmod=+x /gotty/gotty /usr/bin/

EXPOSE 8080

CMD [ "gotty", "--port", "8080", "--permit-write", "--title-format", "Gotty Terminal", "bash" ]
