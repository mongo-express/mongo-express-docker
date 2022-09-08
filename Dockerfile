# https://nodejs.org/en/about/releases/
# https://github.com/nodejs/Release#readme
FROM node:18-alpine3.16

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
ARG MONGO_EXPRESS_REF=master

RUN npm install https://github.com/${MONGO_REPOSITORY}/tree/${MONGO_EXPRESS_REF}/

COPY docker-entrypoint.sh /

WORKDIR /app/node_modules/mongo-express

RUN cp config.default.js config.js
RUN yarn install
RUN yarn build

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["mongo-express"]
