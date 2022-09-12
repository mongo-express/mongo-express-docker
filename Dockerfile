# https://nodejs.org/en/about/releases/
# https://github.com/nodejs/Release#readme
FROM node:18-alpine3.16

WORKDIR /app

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_EDITORTHEME="default" \
    ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    VCAP_APP_HOST="0.0.0.0"

ARG MONGO_REPOSITORY=mongo-express/mongo-express
ARG MONGO_EXPRESS_TAG=v1.0.0
ADD https://github.com/${MONGO_REPOSITORY}/archive/refs/tags/${MONGO_EXPRESS_TAG}.tar.gz /app/${MONGO_EXPRESS_TAG}.tar.gz
RUN set -eux; \
	apk add --no-cache --virtual .me-install-deps git; \
	npm install /app/${MONGO_EXPRESS_TAG}.tar.gz; \
	apk del --no-network .me-install-deps

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

WORKDIR /app/node_modules/mongo-express

RUN apk -U add --no-cache \
    bash \
    # grab tini for signal processing and zombie killing
    tini \
    && yarn install
    # && yarn run build     # prepublish already run build

EXPOSE 8081
ENTRYPOINT [ "/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["mongo-express"]
