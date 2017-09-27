#!/bin/bash

# OBDICONF_KEY           - This worker's key (password)
#                          Default: lOcAlH0St
# OBDICONF_MAN_URLPREFIX - The start of the URL for sending updates to the Manager
#                          Default: https://127.0.0.1
# OBDICONF_MAN_USER      - Username, to send command output to the Manager
#                          Default: worker1
# OBDICONF_MAN_PASSWORD  - Password, to send command output to the Manager
#                          Default: pAsSwOrD

# write /etc/obdi-worker/obdi-worker.conf

cat >/etc/obdi-worker/obdi-worker.conf <<EnD
# The address and port to listen on
#
# Only listen on localhost loopback address on port 8443:
#   listen_address = "127.0.0.1:8443"
#
# To listen on all available interfaces on port 8443:
#   listen_address = "0.0.0.0:8443"
listen_address = "0.0.0.0:4443"

# This worker's key (password)
# Managers must supply a key that matches to access the api.
key = "${OBDICONF_KEY:-lOcAlH0St}"

# Should obdi log to syslog daemon
syslog_enabled = false

# location of system helper scripts
system_scripts = "/var/lib/obdi-worker/scripts"

# The start of the URL for sending updates to the Manager.
#man_urlprefix = "https://127.0.0.1"
#man_urlprefix = "http://127.0.0.1:8888"
man_urlprefix = "${OBDICONF_MAN_URLPREFIX:-https://127.0.0.1}"

# Username and password to send command output to the Manager.
man_user = "${OBDICONF_MAN_USER:-worker1}"
man_password = "${OBDICONF_MAN_PASSWORD:-pAsSwOrD}"

# The directory where scripts are written temporarily
# script_dir = "/var/tmp"
script_dir = "/var/tmp"

# SSL OPTIONS

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
ssl_cert = "/etc/obdi-worker/certs/cert.pem"

# The path and name of the key file
#   ssl_key = "/etc/obdi/certs/key.pem
ssl_key = "/etc/obdi-worker/certs/key.pem"

# No longer used
#transport_timeout = 4
EnD

exec obdi-worker
