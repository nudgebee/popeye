FROM golang:1.23-alpine AS build

WORKDIR /popeye

ENV CGO_ENABLED=0

# Install full build environment
RUN apk --no-cache add build-base git curl ca-certificates

COPY go.mod go.sum main.go Makefile ./
COPY internal internal
COPY cmd cmd
COPY types types
COPY pkg pkg

RUN make build

# -----------------------------------------------------------------------------
FROM alpine:3.21

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /popeye/execs/popeye /bin/popeye

RUN adduser -u 5000 -D nonroot
USER 5000

ENTRYPOINT [ "/bin/popeye" ]
