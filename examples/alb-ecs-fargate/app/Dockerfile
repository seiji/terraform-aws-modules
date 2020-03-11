FROM node:12-alpine3.9
ENV LANG C.UTF-8

WORKDIR /app
ADD . /app

RUN chown -R node:node /app

USER node
RUN npm install --production
CMD node app.js

