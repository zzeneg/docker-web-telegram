FROM node:10-alpine as builder

RUN apk add --no-cache git

WORKDIR /webogram
ADD https://api.github.com/repos/zhukov/webogram/git/refs/heads/master /version.json
RUN git clone https://github.com/zhukov/webogram.git ./ && \
    npm i

# replace web.telegram.org links with proxy
# replace AppId, AppHash and domains
RUN sed -i "s|'https://' + subdomain + '.web.telegram.org/'|'/' + subdomain + '/'|g" ./app/js/lib/mtproto.js && \
    sed -i "s|2496|'{APP_ID}'|g" ./app/js/lib/config.js && \
    sed -i "s|8da85b0d5bfe62527e5b244c209159c3|{APP_HASH}|g" ./app/js/lib/config.js && \
    sed -i "s|'web.telegram.org', 'zhukov.github.io'|'{HOST}'|g" ./app/js/lib/config.js && \
    npm run clean && \
    npm run build


FROM nginx:alpine

COPY --from=builder /webogram/dist /www
COPY --from=builder /webogram/dist/js/app.js /

COPY /nginx.conf /etc/nginx/nginx.conf
COPY /start.sh /
RUN ["chmod", "+x", "/start.sh"]

EXPOSE 80

CMD ["./start.sh"]