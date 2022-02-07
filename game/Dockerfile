FROM node:14-alpine

# user `node` should exist by default
USER node
WORKDIR /app

ENV NODE_ENV="development"

COPY --chown=node:node package.json .
RUN npm install

COPY --chown=node:node . .
