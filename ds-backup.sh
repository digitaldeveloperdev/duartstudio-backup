#!/bin/bash -
#title           :ds-backup.sh
#description     :This script will make a backup of drupal 8 website
#                 directory, database file and send it to Dropbox with Rlone.
#author		 :Duarte Cancela
#date            :2018-07-03
#version         :0.1
#usage		 :bash ds-backup.sh
#notes           :Install tar and Rclone to use this script.
#bash_version    :1.0.0-release
#==============================================================================

# Go to www directory.
cd /var/www/

# Compress Drupal website directory and create a backup directory.
sudo tar -zcvf duartstudio_`date +%d-%m-%Y`.tar.gz duartstudio.com && sudo mkdir backup_`date +%d-%m-%Y`

# Move compressed Drupal 8 directory to backup directory.
sudo mv duartstudio_`date +%d-%m-%Y`.tar.gz ./backup_`date +%d-%m-%Y`

# Enter inside Drupal 8 directory.
cd duartstudio.com

# Create a database backup with drush command and move it to backup directory.
sudo drush sql:dump --result-file=../../duartstudio_drupal8.sql && cd ..
mv duartstudio_drupal8.sql ./backup_`date +%d-%m-%Y`

# Compress the backup directory.
sudo tar -zcvf backup_`date +%d-%m-%Y`.tar.gz backup_`date +%d-%m-%Y` &&

# Backup directory file.tar.gz to Dropbox with Rclone.
sudo rclone copy backup_`date +%d-%m-%Y`.tar.gz duartstudio:duartstudio-backup &&

# Delete backup directory
sudo rm -r backup_`date +%d-%m-%Y`
