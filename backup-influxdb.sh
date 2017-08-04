#!/bin/bash -eu

DOCKER_COMPOSE_FILE="$1"
SERVICE_NAME="$2"
BACKUP_LOCATION="$3"

SERVICE_CMD="docker-compose -f $DOCKER_COMPOSE_FILE exec -T $SERVICE_NAME"
DATE=`date +%Y-%m-%d`

# meta backup
$SERVICE_CMD influxd backup $BACKUP_LOCATION/$DATE/meta

# all databases backup
$SERVICE_CMD influx -execute 'show databases' | tail -n +4 | tr -d '\r' | while read -r DATABASE; do
	$SERVICE_CMD influxd backup -database $DATABASE $BACKUP_LOCATION/$DATE/db-$DATABASE
done

# packing
$SERVICE_CMD sh -c "cd $BACKUP_LOCATION; tar jcf $DATE.tar.bz2 $DATE  &&  rm -rf $BACKUP_LOCATION/$DATE"

# keep only 3 newest backups
$SERVICE_CMD sh -c "cd $BACKUP_LOCATION; find . -regex '\./\d\d\d\d-\d\d-\d\d\.tar\.bz2' | sort -r | tail -n +4 | xargs -r rm"

