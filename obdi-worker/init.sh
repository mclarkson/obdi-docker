#!/bin/bash

# CSV2NAG_DCC

# write csv2nag.conf

#cat >/etc/nagrestconf/csv2nag.conf <<EnD
## Set DCC=1 if this is a data centre collector
#DCC=${CSV2NAG_DCC:-0}
#
## pnp4nagios helper.
##remote_executor="check_nrpe"
#REMOTE_EXECUTOR=${CSV2NAG_REMOTE_EXECUTOR:-"check_any"}
#
## The command used to check freshness (on DCC)
#FRESHNESS_CHECK_COMMAND=${CSV2NAG_FRESHNESS_CHECK_COMMAND:-"no-checks-received"}
#EnD

exec obdi-worker
