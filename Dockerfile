# ベースイメージとして最新のNode.js 18.xを使用
FROM node:18-alpine

# 作業ディレクトリを設定
WORKDIR /var/www/html

# 必要なパッケージをインストール
RUN apk update && \
    npm install -g npm@latest && \ 
    npm install -g @vue/cli

# ポートを公開 (必要に応じて変更)
EXPOSE 8080
