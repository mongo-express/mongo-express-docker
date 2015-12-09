#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

nodeVersion="$(awk '$1 == "FROM" { print $2; exit }' Dockerfile)"

mongoExpressVersion="$(docker run --rm "$nodeVersion" npm show mongo-express version)"

echo "$mongoExpressVersion"

sed -ri "s/^(ENV MONGO_EXPRESS) .*$/\1 $mongoExpressVersion/" Dockerfile
