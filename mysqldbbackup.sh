#!/usr/bin/env bash

MYSQL_USER=
MYSQL_PASSWORD=

BACKUP_DIR=

TIME_FORMAT='%d%m%Y-%H%M'
COMMIT_Time=$(date +"${TIME_FORMAT}")

DATABASES=mysql  -u $MYSQL_USER -p$MYSQL_PASSWORD -Bse 'show databases' | grep -Ev "^(Database|mysql|performance_schema|information_schema)"$

 for db in $DATABASES
        do
                FILE_NAME="${db}.sql"
                mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $db >$BACKUP_DIR/$FILE_NAME
        done


cd $BACKUP_DIR

# move the contents to GIT
git add -A
git commit -m "mysql backup commit ${COMMIT_Time}"
git push -f origin master