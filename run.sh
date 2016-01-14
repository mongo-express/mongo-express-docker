#!/bin/bash
set -e

docker run -it --rm \
	--link web_db_1:mongo \
	--name mongo-express \
	-p 8081:8081 \
	knickers/mongo-express "$@"
