#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

# https://nodejs.org/en/about/releases/
# https://github.com/nodejs/Release#readme
FROM node:18-alpine3.17 as builder

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    ME_CONFIG_SITE_SESSIONSECRET="secret" \
    VCAP_APP_HOST="0.0.0.0"

ARG MONGO_EXPRESS_VERSION=v1.0.2

RUN apk -U add bash git
RUN git clone --depth 1 --branch $MONGO_EXPRESS_VERSION https://github.com/mongo-express/mongo-express.git /app
WORKDIR /app

RUN rm -rf .git
RUN yarn install
RUN yarn build

FROM node:18-alpine3.17

RUN set -eux; \
    apk -U add --no-cache \
        bash \
        # grab tini for signal processing and zombie killing
        tini

# Copy app from builder image
COPY --from=builder /app /app

WORKDIR /app

EXPOSE 8081
COPY docker-entrypoint.sh /
ENTRYPOINT [ "/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["mongo-express"]
