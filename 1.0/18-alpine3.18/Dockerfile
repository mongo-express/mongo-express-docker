#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

# https://nodejs.org/en/about/releases/
# https://github.com/nodejs/Release#readme
FROM node:18-alpine3.18

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    VCAP_APP_HOST="0.0.0.0"

ENV MONGO_EXPRESS_VERSION=1.0.0

RUN set -eux; \
    yarn add mongo-express@${MONGO_EXPRESS_VERSION}; \
    apk -U add --no-cache \
        bash \
        # grab tini for signal processing and zombie killing
        tini

WORKDIR /node_modules/mongo-express

EXPOSE 8081
COPY docker-entrypoint.sh /
ENTRYPOINT [ "/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["mongo-express"]
