FROM node:5.4.1-slim

ENV TINI_VERSION 0.5.0
RUN set -x \
	&& apt-get update && apt-get install -y ca-certificates curl \
		--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -fSL "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini" -o /usr/local/bin/tini \
	&& chmod +x /usr/local/bin/tini \
	&& tini -h \
	&& apt-get purge --auto-remove -y ca-certificates curl

ENV MONGO_EXPRESS 0.30.4

RUN npm install mongo-express@$MONGO_EXPRESS

WORKDIR /node_modules/mongo-express

RUN cp config.default.js config.js

ENV ME_CONFIG_EDITORTHEME="default"
ENV ME_CONFIG_MONGODB_SERVER="mongo"
ENV ME_CONFIG_MONGODB_ENABLE_ADMIN="true"
ENV ME_CONFIG_BASICAUTH_USERNAME=""
ENV ME_CONFIG_BASICAUTH_PASSWORD=""
ENV VCAP_APP_HOST="0.0.0.0"

EXPOSE 8081
CMD ["tini", "--", "node", "app"]
