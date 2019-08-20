#!/bin/bash
# script to backup a site

rm exclude.txt 2>/dev/null
rm sitebackup.tar.gz 2>/dev/null
rm mediabackup.tar.gz 2>/dev/null
rm databasebackup.tar.gz 2>/dev/null
rm databasebackup.sql 2>/dev/null

echo "This script will backup a site so it can be easily downloaded to create a dev site"
read -p "ENTER website domain name (http://www.yahoo.com): " SITE_DOMAIN

cat app/etc/local.xml

read -p "ENTER database host (leave blank for localhost): " DB_HOST

read -p "ENTER database username: " DB_USER

read -p "ENTER database password: " DB_PASS

read -p "ENTER database name: " DB_NAME

echo "media
video
var
*sql
*.gz
*.tar
*.zip
*.psd
*.avi
*.pdf
*.mp4
*.mp3
*.svn" > exclude.txt

tar -czvf sitebackup.tar.gz -X exclude.txt *

echo "Site files have been compressed to $SITE_DOMAIN/sitebackup.tar.gz"

read -p "Press ENTER to tar media files: " NEXT_STEP

rm sitebackup.tar.gz

tar -czvf mediabackup.tar.gz media

echo "Media files have been compressed to $SITE_DOMAIN/mediabackup.tar.gz"

read -p "Press ENTER to dump and tar database: " NEXT_STEP

rm mediabackup.tar.gz

if [ "$DB_HOST" -eq "" ]; then
`mysqldump -H $DB_HOST -u $DB_USER $DB_NAME > databsebackup.sql`
else
`mysqldump -u $DB_USER $DB_NAME > databsebackup.sql`
fi

echo "Database dump done"

tar -czvf databasebackup.tar.gz databsebackup.sql

rm databsebackup.sql

echo "Media files have been compressed to $SITE_DOMAIN/databasebackup.tar.gz"
