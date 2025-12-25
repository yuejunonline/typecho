FROM php:8.2-fpm-alpine
LABEL "language"="php"
LABEL "framework"="typecho"

WORKDIR /app

RUN apk add --no-cache \
    nginx \
    sqlite \
    curl \
    unzip

COPY . /app

RUN mkdir -p /app/usr/themes/waxy && \
    chown -R www-data:www-data /app

RUN mkdir -p /etc/nginx/conf.d && \
    echo 'server { \
        listen 8080; \
        root /app; \
        index index.php; \
        location ~ \.php$ { \
            fastcgi_pass 127.0.0.1:9000; \
            fastcgi_index index.php; \
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
            include fastcgi_params; \
        } \
    }' > /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["sh", "-c", "php-fpm -D && nginx -g \"daemon off;\""]
