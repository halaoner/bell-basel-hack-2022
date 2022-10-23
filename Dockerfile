FROM node:16.17.0-bullseye-slim

WORKDIR /app

COPY /frontend /app

RUN apt update 

RUN apt install -y procps 

RUN apt install -y curl

RUN yarn install

RUN yarn build

RUN yarn run generate

ENV HOST 0.0.0.0

EXPOSE 3000

CMD ["yarn","start"]