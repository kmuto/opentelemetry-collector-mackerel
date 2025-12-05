#!/bin/sh
. /usr/share/debconf/confmodule
db_input high otelcol-mackerel/apikey || true
db_go || true

CONF=/etc/otelcol-mackerel/otelcol-mackerel.conf

if [ "$1" = "configure" ]; then
  if [ -f "$CONF" ]; then
    exit 0
  fi

  db_get otelcol-mackerel/apikey
  if [ "$RET" ]; then
    mkdir -p /etc/otelcol-mackerel
    cat > "$CONF" <<EOF
# Systemd environment file for the otelcol-mackerel service

# Command-line options for the otelcol-mackerel service
OTELCOL_MACKEREL_OPTIONS="--config=mackerel:default"

MACKEREL_APIKEY=$RET
EOF
  fi
fi

if [ "$1" = "configure" ]; then
  adduser --system --group --home /nonexistent --no-create-home --gecos "Mackerel OpenTelemetry Collector" --disabled-password --quiet otelcol-mackerel || true
fi

if command -v systemctl >/dev/null 2>&1; then
  if [ -d /run/systemd/system ]; then
    systemctl daemon-reload
  fi
  if [ -d /run/systemd/system ]; then
    systemctl enable --now otelcol-mackerel.service
  fi
fi
