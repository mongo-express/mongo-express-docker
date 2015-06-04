#!/bin/bash
set -e

docker run -it --rm \
	--name mongo-express \
	--link web_db_1:mongo \
	-e ADMIN_USER="foo" \
	-e ADMIN_PASS="bar" \
	knickers/mongo-express "$@"
