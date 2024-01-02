FROM node:20.10.0-alpine3.19

RUN apk -U add --no-cache bash git

# override some config defaults with values that will work better for docker
ENV ME_CONFIG_MONGODB_ENABLE_ADMIN="true"
ENV ME_CONFIG_MONGODB_URL="mongodb://mongo:27017"
ENV ME_CONFIG_SITE_SESSIONSECRET="secret"
ENV VCAP_APP_HOST="0.0.0.0"

RUN git clone https://github.com/mongo-express/mongo-express.git /app

WORKDIR /app

RUN yarn install
RUN yarn build

EXPOSE 8081
ENTRYPOINT ["npm", "start"]
