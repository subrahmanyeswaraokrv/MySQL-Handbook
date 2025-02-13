root@dev-subrahmanyam-database:/# sudo mkdir -p /mysql/backup/
root@dev-subrahmanyam-database:/# sudo chown mysql:mysql /mysql/backup/
root@dev-subrahmanyam-database:/# sudo vi /mysql/mysql_backup.sh
root@dev-subrahmanyam-database:/#
root@dev-subrahmanyam-database:/# sudo chmod +x /mysql/mysql_backup.sh
root@dev-subrahmanyam-database:/# sudo vi /mysql/mysql_backup.sh

root@dev-subrahmanyam-database:/mysql/backup# cat mysql_backup.sh
cat: mysql_backup.sh: No such file or directory
root@dev-subrahmanyam-database:/mysql/backup# cat /mysql/mysql_backup.sh
#!/bin/bash
#===================================================================================================#
# MySQL Backup using mysqldump                                      Subrahmanyeswarao K             #
# Database : All                                                    Tables : All                    #
# Version : 1.0                                                     Environment : Pre-Prod          #
#===================================================================================================#
# MySQL user and password
MYSQL_USER="root"
MYSQL_PASSWORD='xxxxxxxx'

# Backup directory
BACKUP_DIR="/mysql/backup"

# Date format for backup filename
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Log file for backup process
LOG_FILE="/mysql/backup/backup_log.txt"

# Create a directory for today's backup
BACKUP_PATH="$BACKUP_DIR/$DATE"
mkdir -p "$BACKUP_PATH"

# Start logging
echo "Backup started at $(date)" >> "$LOG_FILE"

# Backup all MySQL databases using mysqldump
mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --all-databases --single-transaction --quick --lock-tables=false | gzip > "$BACKUP_PATH/all_databases_$DATE.sql.gz"

# Check if mysqldump was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully at $(date)" >> "$LOG_FILE"
else
    echo "Backup failed at $(date)" >> "$LOG_FILE"
fi

# Optional: You can remove backups older than 7 days (e.g., if you want to keep backups for a week)
find "$BACKUP_DIR" -type d -mtime +7 -exec rm -rf {} \;

echo "Backup process finished at $(date)" >> "$LOG_FILE"

#NOTE
# Backup Specific Database
# mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" my_database_name | gzip > "$BACKUP_PATH/my_database_$DATE.sql.gz"

#back up the MySQL user accounts and privileges, you can run this command in addition to your database backups:
#mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --no-tablespaces --routines --events mysql > "$BACKUP_PATH/mysql_users_$DATE.sql"

#Backup MySQL InnoDB Data: If you're using InnoDB tables, the --single-transaction flag ensures that the backup is consistent and avoids locking the database during the backup process.
root@dev-subrahmanyam-database:/mysql/backup#
root@dev-subrahmanyam-database:/#
root@dev-subrahmanyam-database:/# ./mysql/mysql_backup.sh
mysqldump: [Warning] Using a password on the command line interface can be insecure.
root@dev-subrahmanyam-database:/#
root@dev-subrahmanyam-database:/# cd /mysql/
root@dev-subrahmanyam-database:/mysql# ll -lhrt
total 1.2G
-rw-r--r--  1 mysql mysql 1.2G Dec 18  2021 mysql-8.0.28-linux-glibc2.12-x86_64.tar.xz
drwxr-xr-x 22 root  root  4.0K Feb 13 10:07 ../
drwx------  2 mysql mysql 4.0K Feb 13 12:55 logs/
-rw-r-----  1 mysql mysql    8 Feb 13 13:04 mysqld.pid
drwx------  7 mysql mysql 4.0K Feb 13 13:19 data/
-rwxr-xr-x  1 root  root  2.1K Feb 13 13:29 mysql_backup.sh*
drwxr-xr-x  5 mysql mysql 4.0K Feb 13 13:29 ./
drwxr-xr-x  3 mysql mysql 4.0K Feb 13 13:29 backup/
root@dev-subrahmanyam-database:/mysql#
root@dev-subrahmanyam-database:/mysql# cd backup/
root@dev-subrahmanyam-database:/mysql/backup# ls
2025-02-13_13-29-18  backup_log.txt
root@dev-subrahmanyam-database:/mysql/backup#
root@dev-subrahmanyam-database:/mysql/backup# cat backup_log.txt
Backup started at Thu Feb 13 01:29:18 PM IST 2025
Backup completed successfully at Thu Feb 13 01:29:18 PM IST 2025
Backup process finished at Thu Feb 13 01:29:18 PM IST 2025
root@dev-subrahmanyam-database:/mysql/backup#
