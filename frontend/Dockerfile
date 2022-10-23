#######################################################
##################### BUILD STAGE #####################
#######################################################
FROM node:lts as builder

WORKDIR /app

COPY . /app

RUN yarn install \ 
    && yarn build \
    && yarn run generate 

#######################################################
##################### FINAL STAGE #####################
#######################################################
FROM node:16.17.0-bullseye-slim as final

WORKDIR /app

COPY --from=builder /app  .

RUN chown -R node:node /app

USER node

ENV HOST 0.0.0.0

EXPOSE 3000

CMD ["yarn","start"]