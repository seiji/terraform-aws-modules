FROM node:12-alpine3.9
ENV LANG C.UTF-8

WORKDIR /app
ADD . /app

VOLUME /app/tmp
RUN chown -R node:node /app

RUN npm install --production
CMD node app.js

USER node
