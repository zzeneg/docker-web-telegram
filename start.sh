#!/bin/sh

test -z $APP_ID && echo "APP_ID is not set" && exit 1
test -z $APP_HASH && echo "APP_HASH is not set" && exit 1
test -z $HOST && echo "HOST is not set" && exit 1

cp /app.js /www/js/app.js

sed -i "s|\"{APP_ID}\"|$APP_ID|" /www/js/app.js
sed -i "s|{APP_HASH}|$APP_HASH|" /www/js/app.js
sed -i "s|{HOST}|$HOST|" /www/js/app.js

nginx -g "daemon off;"