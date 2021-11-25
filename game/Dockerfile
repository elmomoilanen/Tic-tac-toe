FROM node:14-alpine

# user `node` should exist by default
USER node
WORKDIR /app

COPY --chown=node:node . .
RUN npm ci
