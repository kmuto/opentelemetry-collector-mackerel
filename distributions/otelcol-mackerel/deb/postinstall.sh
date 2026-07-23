#!/bin/sh
if [ "$1" = "configure" ]; then
  adduser --system --group --home /nonexistent --no-create-home --gecos "Mackerel OpenTelemetry Collector" --disabled-password --quiet otelcol-mackerel || true
  chown otelcol-mackerel:otelcol-mackerel /etc/otelcol-mackerel /etc/otelcol-mackerel/otelcol-mackerel.conf

  chmod 700 /etc/otelcol-mackerel
  chmod 600 /etc/otelcol-mackerel/otelcol-mackerel.conf
fi

if command -v systemctl >/dev/null 2>&1; then
  if [ -d /run/systemd/system ]; then
    systemctl --system daemon-reload
    systemctl enable --now otelcol-mackerel.service
  fi
fi
