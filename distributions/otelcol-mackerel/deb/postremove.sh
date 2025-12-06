#!/bin/sh
set -e

if [ "$1" = "purge" ]; then
  userdel otelcol-mackerel || true
fi

if [ -d /run/systemd/system ] ; then
  systemctl --system daemon-reload >/dev/null || true
fi
