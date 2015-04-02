FROM node:0.12-slim

ENV MONGO_EXPRESS 0.20.0

RUN npm install mongo-express@$MONGO_EXPRESS

COPY config.js /node_modules/mongo-express/config.js

WORKDIR /node_modules/mongo-express

EXPOSE 8081
CMD ["node", "app"]
