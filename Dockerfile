FROM php:8.2-fpm-alpine
LABEL "language"="php"
LABEL "framework"="typecho"

WORKDIR /app

RUN apk add --no-cache nginx sqlite curl unzip

COPY . /app

RUN mkdir -p /app/usr/themes/waxy
RUN chown -R www-data:www-data /app
RUN mkdir -p /etc/nginx/conf.d

RUN echo 'server {' > /etc/nginx/conf.d/default.conf && \
    echo '    listen 8080;' >> /etc/nginx/conf.d/default.conf && \
    echo '    root /app;' >> /etc/nginx/conf.d/default.conf && \
    echo '    index index.php;' >> /etc/nginx/conf.d/default.conf && \
    echo '    location ~ \.php$ {' >> /etc/nginx/conf.d/default.conf && \
    echo '        fastcgi_pass 127.0.0.1:9000;' >> /etc/nginx/conf.d/default.conf && \
    echo '        fastcgi_index index.php;' >> /etc/nginx/conf.d/default.conf && \
    echo '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/conf.d/default.conf && \
    echo '        include fastcgi_params;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '}' >> /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["sh", "-c", "php-fpm -D && nginx -g \"daemon off;\""]
