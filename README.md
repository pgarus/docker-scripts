# docker-scripts

Collection of scripts used with docker containers.

### Backup scripts

Scripts used to make a complete backup of container's data.

```
./backup-influxdb.sh <docker-compose-file> <docker-compose-service-name> <backup-location-inside-container>
./backup-postgresql.sh <docker-compose-file> <docker-compose-service-name> <backup-location-inside-container>
```
