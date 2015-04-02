#!/bin/bash
set -e

docker run -it --rm \
	--name mongo-express \
	--link web_db_1:mongo \
	knickers/mongo-express "$@"
