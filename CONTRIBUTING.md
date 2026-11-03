# Contributing to netshoot

PRs are welcome. The image is a network troubleshooting toolkit for Docker and Kubernetes. Keep additions focused on that job.

## Adding a tool

- Explain in the PR why the tool is not redundant with something already in the image.
- Prefer an Alpine 3.24 `main` or `community` package. Add it to the `apk add` list in the `Dockerfile`.
- If the package exists only in `edge/testing`, add it with `@testing` (see `trippy` and `swaks`) instead of enabling all of edge.
- If the tool is a pre-built GitHub release binary, add a `get_<tool>()` function in `build/fetch_binaries.sh` with a **pinned version and SHA256**, call it at the bottom of the script, and add a matching `COPY --from=fetcher` line in the Dockerfile.
- Add the tool to `Dockerfile.debian` as well: a Debian package goes in its `apt-get install` list (the comment above that list maps Alpine names to Debian ones), and a pre-built tool goes in its `builder` stage.
- Add the tool to the README **Included Tools** table and a **Troubleshooting Scenarios** block with a real workflow.
- Confirm `linux/amd64` and `linux/arm64` both work.
- Add the binary name to `build/smoke.sh`.

## Local checks

```bash
make build-x86          # faster local iteration
make smoke              # build amd64 and verify advertised tools exist
make smoke-debian       # the same for the Debian image
make build-all          # multi-arch build, no push
```

CI builds both images for amd64, runs the smoke script in each, then does a multi-arch build of both without pushing. Releases are published from `v*` tags.
