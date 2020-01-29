# docker-web-telegram
Containerized telegram web client ([@zhukov/webogram](https://github.com/zhukov/webogram))

This image allows to quickly create a mirror of the official Telegram web client. You can deploy it on your own server if the official client is blocked.

## Requirements
- you should obtain your own api_id and api_hash from Telegram using [this guide](https://core.telegram.org/api/obtaining_api_id)

## Usage
- specify build args:
  - HOST - your domain
  - APP_ID - your app_id from Telegram
  - APP_HASH - your app_hash from Telegram
  - DISABLE_MINIFY - optional parameter to control minifying javascript files. This process requires > 1Gb RAM, if there is not enough RAM, docker process will be killed without any error messages. So if you have a cheap server or something is not working, try to pass this parameter, the only downside is slightly bigger js file.
- docker-compose example
  ```yaml
  telegram:
    container_name: telegram
    build:
      context: https://github.com/zzeneg/docker-web-telegram.git
      args:
        HOST: telegram.mydomain.eu
        APP_ID: your_app_id
        APP_HASH: your_app_hash
        DISABLE_MINIFY: 1
    restart: unless-stopped
    ports:
      - 80:80
  ```
