# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

`netshoot` is a Docker image packed with networking troubleshooting tools for debugging Docker and Kubernetes network issues. The image is built on Alpine Linux and ships ~40 apk packages plus 5 pre-built binaries fetched at build time (ctop, calicoctl, termshark, grpcurl, fortio).

## Build commands

```bash
# Build for amd64 only (faster for local iteration)
make build-x86

# Build for arm64 only
make build-arm64

# Build multi-arch (amd64 + arm64) without pushing
make build-all

# Build and push to Docker Hub (requires login)
make all
```

Direct `docker buildx` invocation for multi-arch local test (mirrors CI):
```bash
docker buildx build --platform linux/amd64,linux/arm64 --output "type=image,push=false" --file ./Dockerfile .
```

There are no unit tests. CI (`test-pr-buildx.yml`) validates PRs by doing a multi-arch build without pushing. Releases are triggered by pushing a `v*` tag and are published to both Docker Hub (`nicolaka/netshoot`) and GHCR (`ghcr.io/nicolaka/netshoot`).

## Architecture

The Dockerfile uses a two-stage build:

1. **`fetcher` stage** (debian:stable-slim) — runs `build/fetch_binaries.sh`, which queries GitHub Releases API for the latest versions of ctop, calicoctl, termshark, grpcurl, and fortio, then downloads and unpacks them into `/tmp/`.

2. **Final stage** (alpine:3.x) — installs all apk packages, copies binaries from the fetcher stage, clones oh-my-zsh + powerlevel10k, and copies `zshrc` and `motd` into the image. Default CMD is `zsh`.

`build/fetch_binaries.sh` auto-detects `x86_64`→`amd64` and `aarch64`→`arm64` to download the right binary for each tool. Add new binary-fetched tools there by following the pattern of the existing `get_*` functions.

## Adding a new tool

- **apk package**: add it alphabetically to the `apk add --no-cache` block in `Dockerfile`.
- **pre-built binary**: add a `get_<tool>()` function in `build/fetch_binaries.sh` and call it at the bottom of the script; then add a `COPY --from=fetcher` line in the Dockerfile's final stage.
- Update the README's "Included Packages" list and add a usage section.
- PRs should justify why the tool is not redundant with existing tools in the image.

## Kubernetes deployment configs

`configs/` contains ready-to-use manifests:
- `netshoot-sidecar.yaml` — deploys netshoot as a sidecar alongside nginx
- `netshoot-calico.yaml` — Calico-specific deployment example
