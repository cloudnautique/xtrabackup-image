#!/bin/bash

set -e

export TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)

: ${USER:="backup"}
: ${PASSWORD:="password"}
: ${BACKUP_TARGET_DIR:="/data/backups"}
: ${DATA_DIR:="/var/lib/mysql"}
: ${HOST:="127.0.0.1"}
: ${DATABASE:="mysql"}
: ${DAYS:=3}

pushd ${BACKUP_TARGET_DIR}

# Make the backup
xtrabackup --backup --target-dir=${BACKUP_TARGET_DIR}/${DATABASE}-${TIMESTAMP} --user=${USER} --password=${PASSWORD} --datadir=${DATA_DIR}/ --host=${HOST}

# Prepare the Backup
xtrabackup --prepare --target-dir=${BACKUP_TARGET_DIR}/${DATABASE}-${TIMESTAMP} --user=${USER} --password=${PASSWORD} --datadir=${DATA_DIR}/ --host=${HOST}
xtrabackup --prepare --target-dir=${BACKUP_TARGET_DIR}/${DATABASE}-${TIMESTAMP} --user=${USER} --password=${PASSWORD} --datadir=${DATA_DIR}/ --host=${HOST}

# Tar the backup.
tar -czvf ${DATABASE}-${TIMESTAMP}.tgz ${DATABASE}-${TIMESTAMP}

# Remove the directory tree
rm -rf ${DATABASE}-${TIMESTAMP}

#delete after three days
find ${BACKUP_TARGET_DIR} -name "*.tgz" -type f -mtime +${DAYS} -exec rm -fr {} \;
