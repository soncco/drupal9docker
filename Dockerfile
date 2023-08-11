FROM php:8-apache

RUN apt-get update \
  && apt-get install -y \
  libzip-dev \
  && docker-php-ext-install -j$(nproc) \
  zip \
  && apt-get purge -y \
  libzip-dev

RUN apt-get install -y vim

RUN apt-get update && apt-get install -y \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  && docker-php-ext-configure gd \
  && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN HOME=/ /usr/local/bin/composer global require drush/drush:~8

RUN a2ensite 000-default ; a2enmod rewrite vhost_alias

# Display version information
RUN php --version
RUN composer --version
RUN /.composer/vendor/drush/drush/drush --version && ln -s /.composer/vendor/drush/drush/drush /usr/bin/drush

ADD https://www.drupal.org/project/drupal /tmp/latest.html

RUN rm -rf /var/www/html ; cd /var/www ; /.composer/vendor/drush/drush/drush -v dl drupal --default-major=7 --drupal-project-rename="html"
RUN chmod a+w /var/www/html/sites/default ; mkdir /var/www/html/sites/default/files ; chown -R www-data:www-data /var/www/html/

WORKDIR /var/www/html
