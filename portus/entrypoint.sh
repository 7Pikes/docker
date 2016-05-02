#!/bin/sh

set -e

i=0
until [ $i -ge 60 ]; do
	mysqladmin ping -h "$PORTUS_PRODUCTION_HOST" --silent && break
	sleep 1
	i=$((i+1))
done

rake assets:precompile
[ "$PORTUS_DB_MIGRATE" = true ] && rake db:migrate

exec "$@"
