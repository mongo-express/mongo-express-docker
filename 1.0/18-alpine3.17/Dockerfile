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

RUN apk -U add git
RUN git clone --depth 1 --branch $MONGO_EXPRESS_VERSION https://github.com/mongo-express/mongo-express.git /app
WORKDIR /app

RUN npm version "$(git describe --tags --dirty)" --no-git-tag-version
RUN yarn install
RUN yarn build

# Remove all files and folders that don't match the desired pattern
RUN find . -maxdepth 1 -type d ! \( \
    -name '.' -o \
    -name '..' -o \
    -name '.yarn' -o \
    -name 'lib' -o \
    -name 'node_modules' -o \
    -name 'public' \
    \) -exec rm -rf {} + -print
RUN find . -maxdepth 1 -type f ! \( \
    -name '.yarnrc.yml' -o \
    -name 'app.js' -o \
    -name 'build-assets.json' -o \
    -name 'config.default.js' -o \
    -name 'package.json' -o \
    -name 'webpack.config.js' -o \
    -name 'yarn.lock' \
    -name 'LICENSE.md' \
    \) -delete -print

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
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["mongo-express"]
