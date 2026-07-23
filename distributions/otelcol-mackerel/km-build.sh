#!/bin/sh
GITHUB_TOKEN=dummy go tool goreleaser release --clean --snapshot -f goreleaser-kmuto.yaml
