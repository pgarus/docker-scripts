#!/bin/bash -eu

DOCKER_COMPOSE_FILE="$1"
SERVICE_NAME="$2"
BACKUP_LOCATION="$3"

SERVICE_CMD="docker-compose -f $DOCKER_COMPOSE_FILE exec -T $SERVICE_NAME"
DATE=`date +%Y-%m-%d`

# backup
$SERVICE_CMD sh -c "cd $BACKUP_LOCATION; cp /var/lib/grafana/grafana.db grafana.db.$DATE  &&  gzip -9 grafana.db.$DATE"

# keep only 3 newest backups
$SERVICE_CMD sh -c "cd $BACKUP_LOCATION; find . -regex '\./grafana\.db\.[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\.gz' | sort -r | tail -n +4 | xargs -r rm"

