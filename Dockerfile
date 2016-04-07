FROM daocloud.io/library/php:5.6.17-fpm
RUN apt-get update

RUN apt-get install -y libcurl4-gnutls-dev libpng-dev libmcrypt-dev libsqlite3-dev
RUN docker-php-ext-install gd mcrypt mbstring json mysql pdo_sqlite pdo_mysql iconv exif
COPY redis-2.2.7.tgz ~/redis.tgz
RUN pecl install ~/redis.tgz
COPY php.ini /usr/local/etc/php/php.ini

RUN apt-get install -y nginx && rm -rf /var/lib/apt/lists/* && echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
COPY nginx_vhost.conf  /etc/nginx/sites-enabled/default

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]

COPY . /www
WORKDIR /www
RUN chown -R www-data:www-data /www

ADD run.sh /run.sh
RUN chmod 755 /run.sh
CMD ["/run.sh"]

EXPOSE 80
EXPOSE 443