FROM golang:latest

RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash -
RUN apt-get update
RUN apt-get install -y nodejs

WORKDIR /gotty
COPY . /gotty
RUN CGO_ENABLED=0 make

FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk --no-cache add ca-certificates && \
    apk add bash

WORKDIR /root

COPY --from=0 --chmod=+x /gotty/gotty /usr/bin/

EXPOSE 8080

CMD ["gotty",  "-w", "bash"]
