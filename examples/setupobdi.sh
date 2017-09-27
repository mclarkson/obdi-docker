#!/bin/bash

# Notes
#
# Improves sqlite performance (type sqlite3, then...)
#
#  PRAGMA journal_mode=WAL;
#  PRAGMA main.wal_checkpoint(PASSIVE);
#  PRAGMA main.synchronous = FULL;
#
# Get IP address of master and a worker
#
#  Using sed:
#
#    docker inspect obdi-master | \
#      sed -n '/"Networks":/,/}/{s/.*IPAddress[^0-9]*\([0-9.]*\).*/\1/p}' 
#
#    docker inspect obdi-worker-1 | \
#      sed -n '/"Networks":/,/}/{s/.*IPAddress[^0-9]*\([0-9.]*\).*/\1/p}'
#
#  Or using JSONPath.sh
#
#    docker inspect obdi-master | JSONPath.sh '.*.*.IPAddress' -b
#
#    docker inspect obdi-worker-1 | JSONPath.sh '.*.*.IPAddress' -b
#

usage() {
    #echo "$0 obdi-master-IP obdi-worker-IP"
    echo "$0 obdi-master-IP"
}
[[ -z $1 ]] && {
    echo "Supply IP Address of obdi api server"
    usage
    exit 1
}
[[ $1 == "-h" ]] && {
    usage
    exit 0
}
#[[ -z $2 ]] && {
#    echo "Supply IP Address of obdi worker"
#    usage
#    exit 1
#}

obdiMasterIp=$1
#obdiWorkerIp=$2

getrandpass() {
    # output a 20 character password
    l=(1 a 2 b 3 c 4 d 5 e 6 f 7 g 8 h 9 i 0 j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
    a="${l[$((RANDOM%62))]}"
    for i in 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9; do
        a="$a${l[$((RANDOM%62))]}"
    done
    echo $a
}

proto="https"
opts="-k -s" # don't check ssl cert, silent
ipport="$1:443"
guid=`curl $opts -d '{"Login":"admin","Password":"admin"}' \
    $proto://$ipport/api/login | grep -o "[a-z0-9][^\"]*"`

echo "GUID=$guid"

# Create users
curl $opts -d '{
    "login":"nomen.nescio",
    "passHash":"nomen",
    "forename":"Nomen",
    "surname":"Nescio",
    "email":"nn@invalid",
    "multilogin":true,
    "enabled":true}' "$proto://$ipport/api/admin/$guid/users"

worker1pass=$(getrandpass)

curl $opts -d '{
    "login":"worker1",
    "passHash":"'"$worker1pass"'",
    "forename":"Testenv Default Worker",
    "surname":"Daemon",
    "email":"worker1@invalid",
    "multilogin":true,
    "enabled":true}' "$proto://$ipport/api/admin/$guid/users"

sduserpass=$(getrandpass)

curl $opts -d '{
    "login":"sduser",
    "passHash":"'"$sduserpass"'",
    "forename":"Secret",
    "surname":"Data",
    "email":"sd@invalid",
    "multilogin":true,
    "enabled":true}' "$proto://$ipport/api/admin/$guid/users"

# Create Data Centres

curl $opts -d '{
    "SysName":"main",
    "DispName":"Main"
    }' "$proto://$ipport/api/admin/$guid/dcs"

# Add the plugin repositories

# Core - for System Jobs
curl $opts -d '{
    "Url":"https://github.com/mclarkson/obdi-core-repository.git"
}' "$proto://$ipport/api/admin/$guid/repos"

# Helloworld plugins
curl $opts -d '{
    "Url":"https://github.com/mclarkson/obdi-dev-repository.git"
}' "$proto://$ipport/api/admin/$guid/repos"

# Add the plugins

curl $opts -d '{
    "Name":"helloworld"
}' "$proto://$ipport/api/admin/$guid/repoplugins"

curl $opts -d '{
    "Name":"helloworld-localdb"
}' "$proto://$ipport/api/admin/$guid/repoplugins"

curl $opts -d '{
    "Name":"helloworld-minimal"
}' "$proto://$ipport/api/admin/$guid/repoplugins"

curl $opts -d '{
    "Name":"helloworld-runscript"
}' "$proto://$ipport/api/admin/$guid/repoplugins"

curl $opts -d '{
    "Name":"systemjobs"
}' "$proto://$ipport/api/admin/$guid/repoplugins"

echo

# Write the envfile used by examples/setupdefworker.sh script

worker1localkey=$(getrandpass)

cat >envfile <<EnD
OBDICONF_KEY=$worker1localkey
OBDICONF_MAN_URLPREFIX=https://${obdiMasterIp}
OBDICONF_MAN_USER=worker1
OBDICONF_MAN_PASSWORD=$worker1pass
EnD
