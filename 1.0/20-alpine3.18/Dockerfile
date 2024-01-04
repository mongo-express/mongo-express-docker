#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

# https://nodejs.org/en/about/releases/
# https://github.com/nodejs/Release#readme
FROM node:20-alpine3.18

RUN set -eux; \
    apk add --no-cache \
        bash \
        # grab tini for signal processing and zombie killing
        tini

WORKDIR /app

ARG MONGO_EXPRESS_VERSION=release/v1.0.2

RUN set -eux; \
    apk add --no-cache --virtual .me-fetch-deps git; \
    git clone --depth 1 --branch "$MONGO_EXPRESS_VERSION" -c advice.detachedHead=false https://github.com/mongo-express/mongo-express.git .; \
    export DISABLE_V8_COMPILE_CACHE=1; \
    yarn install; \
    yarn build; \
    apk del --no-network .me-fetch-deps; \
    rm -rf .git* ~/.cache ~/.yarn

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    ME_CONFIG_SITE_SESSIONSECRET="secret" \
    VCAP_APP_HOST="0.0.0.0"

EXPOSE 8081
COPY docker-entrypoint.sh /
ENTRYPOINT [ "/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["mongo-express"]
