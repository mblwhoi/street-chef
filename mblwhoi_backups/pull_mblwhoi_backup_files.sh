#!/bin/bash

# This script pulls the most recent backup files from the backup manager.

# NOTE: must have access to backup manager machine for library website.
# If you're at WHOI you will probably need to use MBL's VPN.

# path to this dir.
script_dir="$( cd "$( dirname "$0" )" && pwd )"

# Local directory in which to store backups.
local_backups_dir="$script_dir/backup_files"

backup_client="app14.core.cli.mbl.edu"

# core-backup1.cli.mbl.edu
backup_manager="128.128.164.36"

# For each backup folder on the backup manager...
for d in `ssh $backup_client@$backup_manager "find backups -maxdepth 1 -mindepth 1 -type d"`; do

  # Get the path of most recent backup file.
  f=`ssh $backup_client@$backup_manager "ls -d1t $d/** |head -2 |tail -1"`

  # Pull the most recent backup file.
  scp $backup_client@$backup_manager:$f $local_backups_dir/

done


