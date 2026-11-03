# Security policy

netshoot is a **throwaway network debugging image**. It is intentionally large and includes packet capture, scanners, and tracing tools. Treat it as a session, not a long-running sidecar.

## How to report a vulnerability

Open a [GitHub issue](https://github.com/nicolaka/netshoot/issues) or contact the maintainer. Please include the image tag or digest, the scanner output, and whether the finding is in an Alpine package or a pinned binary.

## Using the image safely

- Pin by **digest**, not `:latest`. Alpine package versions can still move when the image is rebuilt.
- Do not run netshoot as a permanent sidecar on every workload.
- Prefer `kubectl debug` / ephemeral containers over privileged host-network sessions unless you need them.
- The `nsenter` Docker recipe requires `--privileged` and a host path mount of `/var/run/docker/netns`. That expands what the session can reach.

## What scanners will find

Image scans will report CVEs. Many are expected:

- The image ships nmap, tshark, Python, Perl, and other large toolchains.
- `ctop` (v0.7.7) and `termshark` (v2.4.0) are pinned to their last upstream releases. Those projects are quiet; the binaries are kept because they are still useful for interactive debugging.
- Other GitHub-release binaries (`grpcurl`, `fortio`) are pinned with SHA256 checksums in `build/fetch_binaries.sh`.

Rebuilding a git tag should fetch the same binary versions. Alpine packages come from the 3.24 repositories (plus tagged `edge/testing` for `trippy` and `swaks` only).
