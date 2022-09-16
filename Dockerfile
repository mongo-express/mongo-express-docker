# https://nodejs.org/en/about/releases/
# https://github.com/nodejs/Release#readme
FROM node:18-alpine3.16

WORKDIR /app

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    VCAP_APP_HOST="0.0.0.0"

ARG MONGO_REPOSITORY=mongo-express/mongo-express
ARG MONGO_EXPRESS_TAG=v1.0.0
ADD https://github.com/${MONGO_REPOSITORY}/archive/refs/tags/${MONGO_EXPRESS_TAG}.tar.gz /app/${MONGO_EXPRESS_TAG}.tar.gz

COPY docker-entrypoint.sh /

RUN set -eux; \
    tar xzf /app/${MONGO_EXPRESS_TAG}.tar.gz --strip-components 1; \
    rm -f /app/${MONGO_EXPRESS_TAG}.tar.gz \
    && chmod +x /docker-entrypoint.sh \
    && apk -U add --no-cache \
        bash \
        # grab tini for signal processing and zombie killing
        tini \
    && yarn install
    # && yarn run build     # prepublish already run build

EXPOSE 8081
ENTRYPOINT [ "/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["mongo-express"]
