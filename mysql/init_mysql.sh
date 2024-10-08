#!/bin/bash
PREFIX=/tmp/mysqld
DATA_PATH=$PREFIX/datadir
SOCKET_PATH=$PREFIX/socket
BASEDIR=./result/bin
# Check existence of /tmp/mysqld/datadir

if [ -d "$DATA_PATH" ]; then
  echo "Directory $DATA_PATH already exists. If you want to reinitialize the MySQL server, remove the directory."
else
    mkdir -p $DATA_PATH
    ./result/bin/mysqld --basedir=$BASEDIR  --datadir $DATA_PATH --initialize-insecure
fi

# This seems like a weird hack...
if [ $(ps -aux | grep $SOCKET_PATH | wc -l) -eq 1 ]; then
  ./result/bin/mysqld --basedir=$BASEDIR --socket $SOCKET_PATH --datadir $DATA_PATH &
  sleep 5 # Wait for the server to start  
  # If the connection doesn't succeed, it means root password has already been executed: we already initialized it.
  ./result/bin/mysql --user=root   --socket $SOCKET_PATH < ./init_db.sql 
else
  echo "MySQL server on that socket is already running."
fi
GAUR_LOG_PATH="$DATA_PATH/gaur.log"

