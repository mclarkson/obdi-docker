#!/bin/bash

usage() {
    echo "$0 obdi-worker-IP"
}
[[ -z $1 ]] && {
    echo "Supply IP Address of obdi worker"
    usage
    exit 1
}

obdiWorkerIp=$2

[[ ! -e envfile ]] && {
    echo "Run setupobdi.sh first (it writes the file, envfile)"
    exit 1
}
[[ -z $OBDICONF_KEY ]] && {
    echo "OBDICONF_KEY was not set in envfile. Re-run setupobdi.sh"
    exit 1
}

source envfile

proto="https"
opts="-k -s" # don't check ssl cert, silent
ipport="$1:443"
guid=`curl $opts -d '{"Login":"admin","Password":"admin"}' \
    $proto://$ipport/api/login | grep -o "[a-z0-9][^\"]*"`

echo "GUID=$guid"

dcid=`curl $opts "$proto://$ipport/api/admin/$guid/dcs?sys_name=main" | grep Id | grep -o "[0-9]"`

curl $opts -d '{
    "SysName":"testenv",
    "DispName":"Test Environment",
    "DcId":'"$dcid"',
    "WorkerUrl":"https://'"$obdiWorkerIp"':4443/",
    "WorkerKey":"'"$OBDICONF_KEY"'"
}' "$proto://$ipport/api/admin/$guid/envs"

# ---------------------------------------------------------------------------
add_perm()
# ---------------------------------------------------------------------------
# $1 - login (text)
# $2 - data centre (text)
# $3 - environment (text)
# $4 - Enabled (true|false)
# $5 - Writeable (true|false)
{
    userid=`curl $opts "$proto://$ipport/api/admin/$guid/users?login=$1" | grep Id | grep -o "[0-9]"`
    dcid=`curl $opts "$proto://$ipport/api/admin/$guid/dcs?sys_name=$2" | grep Id | grep -o "[0-9]"`
    envid=`curl $opts "$proto://$ipport/api/admin/$guid/envs?sys_name=$3&dc_id=$dcid" | grep -w Id | grep -o "[0-9]"`

    echo
    echo "$1 $2 $3 $4 $5"
    echo curl $opts -d '{
        "UserId":'"$userid"',
        "EnvId":'"$envid"',
        "Enabled":true,
        "Writeable":true
    }' "$proto://$ipport/api/admin/$guid/perms"

    curl $opts -d '{
        "UserId":'"$userid"',
        "EnvId":'"$envid"',
        "Enabled":'"$4"',
        "Writeable":'"$5"'
    }' "$proto://$ipport/api/admin/$guid/perms"
}

add_perm nomen.nescio main testenv true true
