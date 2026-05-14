# Contributing

This repository is a **fork** of [derailed/popeye](https://github.com/derailed/popeye)
maintained by Nudgebee. It exists to host the small set of build / CI changes
we need on top of upstream releases. We do **not** accept feature contributions
here.

## Where to send what

- **Bugs, features, and behavior changes in popeye itself** — open an issue or
  pull request against the upstream project:
  <https://github.com/derailed/popeye>.

- **Issues specific to this fork's container image, CI, or Dockerfile** — open
  an issue on this repository.

## Building locally

```shell
make build      # produces ./execs/popeye
make test       # runs the upstream test suite
make img        # builds ghcr.io/nudgebee/popeye:<VERSION>
```

Go 1.23 or newer is required (matches `go.mod`).

## Release process

A push of a tag matching `v*.*.*` triggers `.github/workflows/release.yml`,
which builds a multi-arch image and publishes it to
`ghcr.io/nudgebee/popeye:<tag>` and `:latest`.
