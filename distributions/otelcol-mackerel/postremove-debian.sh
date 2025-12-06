#!/bin/sh
set -e

if [ "$1" = "purge" ]; then
  userdel otelcol-mackerel || true

  if [ -e /usr/share/debconf/confmodule ]; then
    . /usr/share/debconf/confmodule
    db_purge
  fi
fi

if [ "$1" = "remove" ] && [ -d /run/systemd/system ] ; then
        systemctl --system daemon-reload >/dev/null || true
fi
