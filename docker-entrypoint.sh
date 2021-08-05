#!/bin/bash
set -eo pipefail

# if command does not start with mongo-express, run the command instead of the entrypoint
if [ "${1}" != "mongo-express" ]; then
    exec "$@"
fi

function wait_tcp_port {
    local host="$1" port="$2"
    local max_tries="$3" tries=1

    # see http://tldp.org/LDP/abs/html/devref1.html for description of this syntax.
    while ! exec 6<>/dev/tcp/$host/$port && [[ $tries -lt $max_tries ]]; do
        sleep 1s
        tries=$(( tries + 1 ))
        echo "$(date) retrying to connect to $host:$port ($tries/$max_tries)"
    done
    exec 6>&-
}

# if ME_CONFIG_MONGODB_URL has a comma in it, we're pointing to a replica set (https://github.com/mongo-express/mongo-express-docker/issues/21)
if [[ "$ME_CONFIG_MONGODB_URL" != *,* ]]; then
    work=$ME_CONFIG_MONGODB_URL
    # Remove the scheme (should be "mongodb://" or "mongodb+srv://").
    work=${work#*://}
    # Remove the path component of the URL (should just be a "/").
    work=${work%%/*}
    # Remove the userinfo.
    work=${work#*@}
    if [[ "$work" = *:* ]]; then
        # Match the host.
        host=${work%:*}
        # Match the port.
        port=${work#*:}
    else
        host=$work
        port=27017
    fi

    # wait for the mongo server to be available
    echo "Waiting for $host:$port..."
    wait_tcp_port "$host" "$port"
fi

# run mongo-express
exec node app
