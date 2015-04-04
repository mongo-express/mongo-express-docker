FROM node:0.12-slim

ENV MONGO_EXPRESS 0.20.0

RUN npm install mongo-express@$MONGO_EXPRESS

WORKDIR /node_modules/mongo-express

RUN sed -r \
	-e "s/(server:) 'localhost'/\1 'mongo'/" \
	-e "s/(adminUsername:) 'admin'/\1 ''/" \
	-e "s/(adminPassword:) 'pass'/\1 ''/" \
	config.default.js > config.js

EXPOSE 8081
CMD ["node", "app"]
