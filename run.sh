#!/bin/bash
set -e

docker run -it --rm \
	--link web_db_1:mongo \
	--name mongo-express-docker \
	-p 8081:8081 \
	-e ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" \
	mongo-express-docker "$@"
