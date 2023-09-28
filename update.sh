#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

# TODO: Add new version update
./apply-templates.sh "$@"
