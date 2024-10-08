#!/bin/bash
PREFIX=/tmp/mysqld_00

DATA_PATH=$PREFIX/datadir
SOCKET_PATH=$PREFIX/socket
BASEDIR=./result/bin
S_HOSTNAME=$(hostname -s)

# This seems like a weird hack...
if [ $(ps -aux | grep $SOCKET_PATH | wc -l) -eq 1 ]; then
  ./result/bin/mysqld --log-error --basedir=$BASEDIR --socket $SOCKET_PATH --datadir $DATA_PATH --port 61337 &
  sleep 5 # Wait for the server to start  
  # If the connection doesn't succeed, it means root password has already been executed: we already initialized it.
  ./result/bin/mysql --user=root   --socket $SOCKET_PATH < ./init_db.sql 
else
  echo "MySQL server on that socket is already running."
fi

echo "Reading log at $DATA_PATH/$S_HOSTNAME.err"
cat $DATA_PATH/$S_HOSTNAME.err


