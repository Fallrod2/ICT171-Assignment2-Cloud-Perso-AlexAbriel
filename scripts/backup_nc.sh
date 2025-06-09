#!/usr/bin/env bash
cd "$(dirname "$0")/.."
docker-compose stop app
tar czf logs/backup_$(date +%F).tar.gz nextcloud_data/
# optional : rclone copy logs/backup_*.tar.gz remote:backups
docker-compose start app
