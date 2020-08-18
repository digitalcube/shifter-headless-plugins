#!/bin/bash

find plugins/ -type d -name vendor -prune -o -type f -name "*.php" -print0 | xargs -n 1 -0 php -l

# ./vendor/bin/phpcs --config-set installed_paths "$(pwd)/vendor/wp-coding-standards/wpcs"
# ./vendor/bin/phpcs -p -s -v --standard=WordPress /srv/plugins
