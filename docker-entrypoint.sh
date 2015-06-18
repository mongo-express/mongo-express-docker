#!/bin/bash
set -e

sed -r \
	-e "s/(port:) 27017/\1 '$MONGO_PORT'/" \
	-e "s/(server:) 'localhost'/\1 'mongo'/" \
	-e "s/(username:) 'user'/\1 '$WEB_USER'/" \
	-e "s/(password:) 'pass'/\1 '$WEB_PASS'/" \
	-e "s/(adminUsername:) 'admin'/\1 '$ADMIN_USER'/" \
	-e "s/(adminPassword:) 'pass'/\1 '$ADMIN_PASS'/" \
	-e "s/(editorTheme:) \"rubyblue\"/\1 '$EDITOR_THEME'/" \
	config.default.js > config.js

exec "$@"
