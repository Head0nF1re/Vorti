FROM node:20 AS builder

USER node

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
CMD ["npm", "run", "dev"]
