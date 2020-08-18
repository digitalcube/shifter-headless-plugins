#!/bin/bash
env
if [ "$REPORT" == "1" ]; then
  ./vendor/bin/phpcs --config-set installed_paths "$(pwd)/vendor/wp-coding-standards/wpcs"
  # ./vendor/bin/phpcs -snp --no-colors --report=source --report-diff=/srv/results/report-diff.log --report-full=/srv/results/report-full.log --standard=./phpcs.xml
  ./vendor/bin/phpcs -snp --no-colors --report=source --report-summary=/srv/results/report-summary.log --report-full=/srv/results/report-full.log --standard=./phpcs.xml
fi

find plugins/ -type d -name vendor -prune -o -type f -name "*.php" -print0 | xargs -n 1 -0 php -l

