#!/bin/bash
set -eo pipefail

# if command does not start with mongo-express, run the command instead of the entrypoint
if [ "${1}" != "mongo-express" ]; then
    exec "$@"
fi

function wait_tcp_port {
    local host="$1" port="$2"
    local max_tries=5 tries=1

    # see http://tldp.org/LDP/abs/html/devref1.html for description of this syntax.
    while ! exec 6<>/dev/tcp/$host/$port && [[ $tries -lt $max_tries ]]; do
        sleep 1s
        tries=$(( tries + 1 ))
        echo "$(date) retrying to connect to $host:$port ($tries/$max_tries)"
    done
    exec 6>&-
}

# from https://github.com/docker-library/mongo/blob/master/4.1/docker-entrypoint.sh
# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"

    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi

    local val="$def"

    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi

    export "$var"="$val"
    unset "$fileVar"
}

# set env variables to content of the following {VAR}_FILE env variables
file_env 'ME_CONFIG_BASICAUTH_USERNAME'
file_env 'ME_CONFIG_BASICAUTH_PASSWORD'
file_env 'ME_CONFIG_MONGODB_ADMINUSERNAME'
file_env 'ME_CONFIG_MONGODB_ADMINPASSWORD'
file_env 'ME_CONFIG_SITE_COOKIESECRET'
file_env 'ME_CONFIG_SITE_SESSIONSECRET'

# wait for the mongo server to be available
echo Waiting for ${ME_CONFIG_MONGODB_SERVER}:${ME_CONFIG_MONGODB_PORT:-27017}...
wait_tcp_port "${ME_CONFIG_MONGODB_SERVER}" "${ME_CONFIG_MONGODB_PORT:-27017}"

# run mongo-express
exec node app
