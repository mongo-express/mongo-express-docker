#!/bin/bash
set -eo pipefail

# if command does not start with mongo-express, run the command instead of the entrypoint
if [ "${1}" != "mongo-express" ]; then
    exec "$@"
fi

# wait for the mongo serveur to be available
echo Waiting for ${ME_CONFIG_MONGODB_SERVER}:${ME_CONFIG_MONGODB_PORT:-27017}...
wait-port ${ME_CONFIG_MONGODB_SERVER}:${ME_CONFIG_MONGODB_PORT:-27017} --timeout 20000

# run mongo-express
exec node app
