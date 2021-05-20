# FROM node:12.19.0-alpine3.9 AS development
# WORKDIR /usr/src/app
# COPY package*.json ./
# RUN npm install glob rimraf
# RUN npm install --only=development
# COPY . .
# RUN npm run build

# FROM node:12.19.0-alpine3.9 as production
# ARG NODE_ENV=production
# ENV NODE_ENV=${NODE_ENV}
# WORKDIR /usr/src/app
# COPY package*.json ./
# RUN npm install --only=production
# COPY . .
# COPY --from=development /usr/src/app/dist ./dist
# CMD ["node", "dist/main"]


FROM node:12.14 AS build
WORKDIR /usr/src/app
COPY package*.json ./
RUN yarn
COPY . .
RUN yarn run build

FROM node:12.14-alpine
WORKDIR /usr/src/app
EXPOSE 3000
# RUN apk add --no-cache curl
ENV NODE_ENV production
COPY --from=build /usr/src/app /usr/src/app
ENTRYPOINT [ "yarn", "run" ]
CMD [ "start:prod" ]
