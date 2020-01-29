FROM node:10-alpine as builder

ARG HOST
ARG APP_ID
ARG APP_HASH
ARG DISABLE_MINIFY

RUN apk add --no-cache git

WORKDIR /webogram
ADD https://api.github.com/repos/zhukov/webogram/git/refs/heads/master /version.json
RUN git clone https://github.com/zhukov/webogram.git ./ && \
    npm i

# replace web.telegram.org links with proxy
# replace AppId, AppHash and domains
# disable minify (requires > 1Gb memory)
RUN sed -i "s|'https://' + subdomain + '.web.telegram.org/'|'/' + subdomain + '/'|g" ./app/js/lib/mtproto.js && \
    sed -i "s|2496|${APP_ID}|g" ./app/js/lib/config.js && \
    sed -i "s|8da85b0d5bfe62527e5b244c209159c3|${APP_HASH}|g" ./app/js/lib/config.js && \
    sed -i "s|'web.telegram.org', 'zhukov.github.io'|\"${HOST}\"|g" ./app/js/lib/config.js && \
    if [[ -n "${DISABLE_MINIFY}" ]] ; then sed -i "s|'concat', $.ngAnnotate(), $.uglify({ outSourceMap: false })|'concat'|g" ./gulpfile.js ; fi && \
    npm run clean && \
    npm run build


FROM nginx:alpine

COPY --from=builder /webogram/dist /www

COPY /nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]