# docker-web-telegram
Containerized telegram web client ([@zhukov/webogram](https://github.com/zhukov/webogram))

This image allows to quickly create a mirror of the official Telegram web client. You can deploy it on your own server if the official client is blocked.

## Requirements
- you should obtain your own api_id and api_hash from Telegram using [this guide](https://core.telegram.org/api/obtaining_api_id)

## Usage
- specify environment variables:
  - HOST - your domain
  - APP_ID - your app_id from Telegram
  - APP_HASH - your app_hash from Telegram
- docker-compose example
  ```yaml
  telegram:
    container_name: telegram
    image: zzeneg/web-telegram
    restart: unless-stopped
    ports:
      - 80:80
    environment:
      HOST: telegram.mydomain.eu
      APP_ID: your_app_id
      APP_HASH: your_app_hash
  ```
