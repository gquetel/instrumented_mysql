#!/bin/bash
DATA_PATH=/tmp/mysqld/datadir
SOCKET_PATH=/tmp/mysqld/socket
# Check existence of /tmp/mysqld/datadir

if [ -d "$DATA_PATH" ]; then
  echo "Directory $DATA_PATH already exists. If you want to reinitialize the MySQL server, remove the directory."
else
    mkdir -p /tmp/mysqld/datadir
    ./result/bin/mysqld   --datadir /tmp/mysqld/datadir --initialize-insecure
fi

# This seems like a weird hack...
if [ $(ps -aux | grep "/tmp/mysqld/socket" | wc -l) -eq 1 ]; then
  ./result/bin/mysqld --socket $SOCKET_PATH --datadir /tmp/mysqld/datadir &
  sleep 5 # Wait for the server to start  
  ./result/bin/mysql --user=root   --socket $SOCKET_PATH < ./init_db.sql 
else
  echo "MySQL server on that socket is already running."
fi
GAUR_LOG_PATH="$DATA_PATH/gaur.log"

echo "GAUR log file is located at $GAUR_LOG_PATH"
