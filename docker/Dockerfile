FROM google/nodejs
WORKDIR /app
ADD . /app
RUN (cd programs/server && npm install)
EXPOSE 8080
CMD []
ENV PORT 8080
ENV ROOT_URL http://130.211.161.10
ENTRYPOINT MONGO_URL=mongodb://$MONGO_SERVICE_HOST:$MONGO_SERVICE_PORT /nodejs/bin/node main.js
