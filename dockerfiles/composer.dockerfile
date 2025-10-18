FROM composer:2.5.7

WORKDIR /var/www/html

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]