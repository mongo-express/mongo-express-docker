# https://nodejs.org/en/about/releases/
# https://github.com/nodejs/Release#readme
FROM node:18-alpine3.16

RUN apk -U add --no-cache bash tini

RUN mkdir /app
WORKDIR /app

EXPOSE 8081

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_EDITORTHEME="default" \
    ME_CONFIG_MONGODB_URL="mongodb://mongo:27017" \
    ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    ME_CONFIG_BASICAUTH_USERNAME="" \
    ME_CONFIG_BASICAUTH_PASSWORD="" \
    VCAP_APP_HOST="0.0.0.0"

ARG MONGO_REPOSITORY=mongo-express/mongo-express
ARG MONGO_EXPRESS_TAG=v1.0.0
ADD https://github.com/${MONGO_REPOSITORY}/archive/refs/tags/${MONGO_EXPRESS_TAG}.tar.gz /app/${MONGO_EXPRESS_TAG}.tar.gz
RUN npm install /app/${MONGO_EXPRESS_TAG}.tar.gz

COPY docker-entrypoint.sh /

WORKDIR /app/node_modules/mongo-express

RUN cp config.default.js config.js
RUN yarn install
RUN npm run build

ENTRYPOINT [ "tini", "--", "/docker-entrypoint.sh"]
CMD ["mongo-express"]
