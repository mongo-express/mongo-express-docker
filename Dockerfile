FROM node:0.12-slim

ENV MONGO_EXPRESS 0.20.0

RUN npm install mongo-express@$MONGO_EXPRESS

WORKDIR /node_modules/mongo-express

ENV WEB_USER 'user'
ENV WEB_PASS 'pass'
ENV ADMIN_USER ''
ENV ADMIN_PASS ''

COPY docker-entrypoint.sh ./
ENTRYPOINT ["./docker-entrypoint.sh"]

EXPOSE 8081
CMD ["node", "app"]
