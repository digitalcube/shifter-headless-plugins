FROM php:7.3-cli-buster as composer
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update  --allow-releaseinfo-change --allow-insecure-repositories \
  && apt-get upgrade -y && apt-get install -y unzip

WORKDIR /tmp
# Note: pinning install > php composer-setup.php --version=1.5.6

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && install -m 0755 ./composer.phar /usr/local/bin/composer

RUN /usr/local/bin/composer --version

RUN docker-php-ext-enable zip
