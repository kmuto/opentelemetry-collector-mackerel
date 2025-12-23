#!/bin/sh
. /usr/share/debconf/confmodule
db_input high otelcol-mackerel/apikey || true
db_go || true

if [ "$1" = "configure" ]; then
  db_get otelcol-mackerel/apikey
  if [ "$RET" ]; then
    sed -i -e "/\# MACKEREL_APIKEY=your-api-key-here/c\MACKEREL_APIKEY=$RET" /etc/otelcol-mackerel/otelcol-mackerel.conf
  fi

  adduser --system --group --home /nonexistent --no-create-home --gecos "Mackerel OpenTelemetry Collector" --disabled-password --quiet otelcol-mackerel || true
  chown otelcol-mackerel:otelcol-mackerel /etc/otelcol-mackerel /etc/otelcol-mackerel/otelcol-mackerel.conf
  chmod 700 /etc/otelcol-mackerel
  chmod 600 /etc/otelcol-mackerel/otelcol-mackerel.conf
fi

if command -v systemctl >/dev/null 2>&1; then
  if [ -d /run/systemd/system ]; then
    systemctl daemon-reload
  fi
  if [ -d /run/systemd/system ]; then
    systemctl enable --now otelcol-mackerel.service
  fi
fi
