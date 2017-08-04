#!/bin/bash -eu

DOCKER_COMPOSE_FILE="$1"
SERVICE_NAME="$2"
BACKUP_LOCATION="$3"

SERVICE_CMD="docker-compose -f $DOCKER_COMPOSE_FILE exec -T $SERVICE_NAME"
DATE=`date +%Y-%m-%d`

# backup
$SERVICE_CMD pg_dumpall -c -U postgres --quote-all-identifiers -f $BACKUP_LOCATION/$DATE.sql

# packing
$SERVICE_CMD bzip2 -9 $BACKUP_LOCATION/$DATE.sql

# keep only 3 newest backups
$SERVICE_CMD sh -c "cd $BACKUP_LOCATION; find . -regex '\./\d\d\d\d-\d\d-\d\d\.sql\.bz2' | sort -r | tail -n +4 | xargs -r rm"
