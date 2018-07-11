FROM node:8-slim

# grab tini for signal processing and zombie killing
ENV TINI_VERSION 0.18.0
RUN set -x \
	&& apt-get update && apt-get install -y ca-certificates curl \
		--no-install-recommends \
	&& dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& curl -fSL "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-$dpkgArch" -o /usr/local/bin/tini \
	&& curl -fSL "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-$dpkgArch.asc" -o /usr/local/bin/tini.asc \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 \
	&& gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
	&& rm -r "$GNUPGHOME" /usr/local/bin/tini.asc \
	&& chmod +x /usr/local/bin/tini \
	&& tini -h \
	&& apt-get purge --auto-remove -y ca-certificates curl \
	&& rm -rf /var/lib/apt/lists/*

EXPOSE 8081

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_EDITORTHEME="default" \
    ME_CONFIG_MONGODB_SERVER="mongo" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    ME_CONFIG_BASICAUTH_USERNAME="" \
    ME_CONFIG_BASICAUTH_PASSWORD="" \
    VCAP_APP_HOST="0.0.0.0"

ENV MONGO_EXPRESS 0.49.0

RUN npm install mongo-express@$MONGO_EXPRESS

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

WORKDIR /node_modules/mongo-express

RUN cp config.default.js config.js

ENTRYPOINT [ "tini", "--", "/docker-entrypoint.sh"]
CMD ["mongo-express"]
