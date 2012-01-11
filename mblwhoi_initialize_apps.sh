#!/bin/bash

# This script assumes that backup files have been downloaded to
# mblwhoi_backups/backup_files, and that mblwhoi_capistrano_recipes
# is in the same directory as this file.

# path to this file's dir.
script_dir="$( cd "$( dirname "$0" )" && pwd )"

# Change into the capistrano recipes folder.
cd $script_dir/mblwhoi_capistrano_recipes;

# For each app config line...
for l in `cat $script_dir/mblwhoi_app_configs.csv`; do

  # Split line on comma to get app_id and app namespace.
  config_parts=($(echo $l |tr "," "\n"));
  app_id=${config_parts[0]};
  app_ns=${config_parts[1]};

  # Get the backup file for the app.
  backup_file=`ls -d -1 $script_dir/mblwhoi_backups/backup_files/*${app_id}_daily.tar.gz`

  # Deploy the app.
  cap mblwhoi_drupal:deploy -S "stage=streetchef_${app_ns}" -S "app=${app_ns}/${app_id}";

  # Initialize the app by restoring from backup.
  cap mblwhoi_drupal:restore_from_backup -S "stage=streetchef_${app_ns}" -S "app=${app_ns}/${app_id}" -S "backup_file=${backup_file}";

done

echo "Done initializing MBLWHOI applications."
echo