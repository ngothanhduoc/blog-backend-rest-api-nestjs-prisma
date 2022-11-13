###################
# BUILD FOR LOCAL DEVELOPMENT
###################
FROM node:16 AS development

RUN apt-get update
RUN apt-get install -y openssl

ENV NODE_ENV=development

WORKDIR /code
COPY package.json /code/package.json
COPY yarn.lock /code/yarn.lock

RUN yarn

COPY . /code

RUN npx prisma generate

EXPOSE 3000


###################
# BUILD FOR PRODUCTION
###################
FROM node:16-slim As build

RUN apt-get update
RUN apt-get install -y openssl

ENV NODE_ENV=production

WORKDIR /code
COPY package.json /code/package.json
COPY yarn.lock /code/yarn.lock
COPY --from=development /code/node_modules /code/node_modules
COPY . /code

RUN npx prisma generate
RUN yarn build
RUN yarn install --frozen-lockfile --production && yarn cache clean


###################
# PRODUCTION
###################

FROM node:16-slim As production

RUN apt-get update
RUN apt-get install -y openssl

ENV NODE_ENV=production

WORKDIR /code
COPY --from=build /code/node_modules /code/node_modules
COPY --from=build /code/dist /code/dist
COPY --from=build /code/prisma /code/prisma

EXPOSE 3000

CMD [ "node", "dist/main.js" ]
