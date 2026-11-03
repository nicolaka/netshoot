# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

`netshoot` is a Docker image packed with networking troubleshooting tools for debugging Docker and Kubernetes network issues. The image is built on Alpine Linux 3.24 and ships apk packages plus 4 pre-built binaries fetched at build time (ctop, termshark, grpcurl, fortio).

## Build commands

```bash
# Build for amd64 only (faster for local iteration)
make build-x86

# Build for arm64 only
make build-arm64

# Build multi-arch (amd64 + arm64) without pushing — default target
make build-all

# Build amd64 and verify advertised tools exist
make smoke

# Push a locally tagged image
make push

# Multi-arch build and push
make release
```

`VERSION` comes from `git describe --tags --always --dirty` and is passed as a build-arg into the image labels and motd.

There are no unit tests. CI (`test-pr-buildx.yml`) builds amd64, runs `build/smoke.sh`, then does a multi-arch build without pushing. Releases are triggered by pushing a `v*` tag and are published to both Docker Hub (`nicolaka/netshoot`) and GHCR (`ghcr.io/nicolaka/netshoot`).

## Architecture

The Dockerfile uses a two-stage build:

1. **`fetcher` stage** (debian:stable-slim) — runs `build/fetch_binaries.sh`, which downloads **pinned** versions of ctop, termshark, grpcurl, and fortio and verifies SHA256 checksums into `/tmp/`.

2. **Final stage** (alpine:3.24) — installs apk packages from stable `main`/`community`, plus `trippy` and `swaks` from tagged `edge/testing`. It copies binaries from the fetcher stage, unpacks pinned oh-my-zsh / zsh-autosuggestions / powerlevel10k tarballs, and copies `shell/zshrc` and `shell/motd` into the image. Default CMD is `zsh`.

`build/fetch_binaries.sh` maps `x86_64`→`amd64` and `aarch64`→`arm64`. Add new binary-fetched tools there by following the existing `get_*` functions (pinned version + checksum per arch).

## Adding a new tool

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Kubernetes / Compose examples

`configs/` contains ready-to-use manifests:

- `netshoot-sidecar.yaml` — netshoot as a sidecar alongside nginx
- `netshoot-compose.yaml` — capture traffic from a Compose service
