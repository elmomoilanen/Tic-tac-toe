FROM node:16-alpine

USER node
WORKDIR /app

ENV NODE_ENV="development"

COPY --chown=node:node package*.json ./
RUN npm install

COPY --chown=node:node . .
