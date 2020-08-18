FROM php:7.4-cli-buster
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update  --allow-releaseinfo-change --allow-insecure-repositories \
  && apt-get upgrade -y && apt-get install -y unzip git bash

WORKDIR /tmp
# Note: pinning install > php composer-setup.php --version=1.5.6

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && install -m 0755 ./composer.phar /usr/local/bin/composer

COPY composer.json /srv/composer.json
COPY php.ini /usr/local/etc/php/php.ini

WORKDIR /srv
RUN composer install
COPY entry.sh /srv/entry.sh

CMD ["/srv/entry.sh"]
