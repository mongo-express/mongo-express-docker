FROM node:0.12-slim

ENV MONGO_EXPRESS 0.20.0
ENV MONGO_EXPRESS_DIR /node_modules/mongo-express

RUN npm install mongo-express@$MONGO_EXPRESS

RUN cd $MONGO_EXPRESS_DIR && sed \
	-e "s/server: 'localhost'/server: 'mongo'/" \
	-e "s/adminUsername: 'admin'/adminUsername: ''/" \
	-e "s/adminPassword: 'pass'/adminPassword: ''/" \
	< config.default.js > config.js

WORKDIR $MONGO_EXPRESS_DIR

EXPOSE 8081
CMD ["node", "app"]
