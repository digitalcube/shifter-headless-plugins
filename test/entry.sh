#!/bin/bash

# exec bash -c "sleep 3600"

./vendor/bin/phpcs --config-set installed_paths "$(pwd)/vendor/wp-coding-standards/wpcs"
./vendor/bin/phpcs -p -s -v --standard=WordPress /srv/plugins
