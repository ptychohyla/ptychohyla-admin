FROM node:18-alpine
WORKDIR /web/
COPY web/. .
RUN yarn install --registry=https://registry.npmmirror.com
RUN yarn build

FROM nginx:alpine
COPY ./docker_env/nginx/my.conf /etc/nginx/conf.d/my.conf
COPY --from=0 /web/dist /usr/share/nginx/html
