#!/bin/bash

[[ -n $OBDICONF_DATABASE_PATH ]] && \
    mkdir -p $(dirname "$OBDICONF_DATABASE_PATH")

[[ -n $OBDICONF_PLUGIN_DATABASE_PATH ]] && \
    mkdir -p "$OBDICONF_PLUGIN_DATABASE_PATH"

[[ -n $OBDICONF_GO_PLUGIN_DIR ]] && \
    mkdir -p "$OBDICONF_GO_PLUGIN_DIR"

[[ -n $OBDICONF_STATIC_CONTENT ]] && {  \
    mkdir -p "$OBDICONF_STATIC_CONTENT"
    OBDICONF_GO_PLUGIN_SOURCE="$OBDICONF_STATIC_CONTENT/plugins"
    mkdir -p "$OBDICONF_GO_PLUGIN_SOURCE"
}

[[ -n $OBDICONF_SESSION_TIMEOUT ]] && \
    mkdir -p "$OBDICONF_SESSION_TIMEOUT"

cat >/etc/obdi/obdi.conf <<EnD
# ---------------------------------------------------------------------------
# GENERAL OPTIONS
# ---------------------------------------------------------------------------

# The path and name of the database file.
database_path = "${OBDICONF_DATABASE_PATH:-/var/lib/obdi/manager.db}"

# Directory to serve static content from
static_content = "${OBDICONF_STATIC_CONTENT:-/usr/share/obdi/static/}"

# The address and port to listen on
#
# Only listen on localhost loopback address on port 443:
#   listen_address = "127.0.0.1:443"
#
# To listen on all available interfaces on port 443:
#   listen_address = "0.0.0.0:443"
listen_address = "0.0.0.0:443"

# Directory to store cache files
cache_dir = "/var/cache/obdi"

# Proxy setting ( for git  )
http_proxy = ""
https_proxy = ""

# Should obdi log to syslog daemon
syslog_enabled = false

# ---------------------------------------------------------------------------
# GUI OPTIONS
# ---------------------------------------------------------------------------

# User's session inactivity timeout in minutes
session_timeout = ${OBDICONF_SESSION_TIMEOUT:-10}

# ---------------------------------------------------------------------------
# PLUGIN OPTIONS
# ---------------------------------------------------------------------------

# The path for additional sqlite3 plugin databases.
plugin_database_path = "${OBDICONF_PLUGIN_DATABASE_PATH:-/var/lib/obdi/plugins/}"

# Compiled plugin directory
go_plugin_dir = "${OBDICONF_GO_PLUGIN_DIR:-/usr/lib/obdi/plugins}"

# Plugin source code repository directory
go_plugin_source = "${OBDICONF_GO_PLUGIN_SOURCE:-/usr/share/obdi/static/plugins}"

# Plugin port start number
go_plugin_port_start = 50000

# GOROOT for compiling plugins
go_root = "/usr/lib/golang"

# ---------------------------------------------------------------------------
# SSL OPTIONS
# ---------------------------------------------------------------------------

# Whether SSL is enabled
#
# To disable SSL:
#   ssl_enabled = false
#
# To enable SSL:
#   ssl_enabled = true
ssl_enabled = true

# The path and name of the certificate file
#   ssl_cert = "/etc/obdi/certs/cert.pem
ssl_cert = "/etc/obdi/certs/cert.pem"

# The path and name of the key file
#   ssl_key = "/etc/obdi/certs/key.pem
ssl_key = "/etc/obdi/certs/key.pem"

# ---------------------------------------------------------------------------
# NETWORKING OPTIONS
# ---------------------------------------------------------------------------

# No longer used
#transport_timeout = 4
EnD

exec obdi
