FROM golang:1.26.10-alpine AS build

WORKDIR /popeye

# GOTOOLCHAIN=local: build with the image's Go, never a toolchain go.mod asks to
# download, so the stdlib baked into the binary is the one pinned above.
ENV CGO_ENABLED=0 GOTOOLCHAIN=local

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

# Pick up OS package fixes (openssl, musl, zlib) published after the base tag.
RUN apk upgrade --no-cache

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /popeye/execs/popeye /bin/popeye

RUN adduser -u 5000 -D nonroot
USER 5000

ENTRYPOINT [ "/bin/popeye" ]
