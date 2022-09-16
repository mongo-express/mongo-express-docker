# https://nodejs.org/en/about/releases/
# https://github.com/nodejs/Release#readme
FROM node:18-alpine3.16

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    VCAP_APP_HOST="0.0.0.0"

ARG MONGO_EXPRESS_VERSION=1.0.0

COPY docker-entrypoint.sh /

RUN set -eux; \
    yarn add mongo-express@${MONGO_EXPRESS_VERSION}; \
    chmod +x /docker-entrypoint.sh; \
    apk -U add --no-cache \
        bash \
        # grab tini for signal processing and zombie killing
        tini

WORKDIR /node_modules/mongo-express

EXPOSE 8081
ENTRYPOINT [ "/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["mongo-express"]
