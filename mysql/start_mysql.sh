#!/bin/bash
S_HOSTNAME=$(hostname -s)
PREFIX=~/tmp/$S_HOSTNAME/mysqld

DATA_PATH=$PREFIX/datadir
SOCKET_PATH=$PREFIX/socket
BASEDIR=./result/bin
S_HOSTNAME=$(hostname -s)

./result/bin/mysqld --log-error --basedir=$BASEDIR --socket $SOCKET_PATH --datadir $DATA_PATH --port 61337 &
sleep 5 # Wait for the server to start  
# If the connection doesn't succeed, it means root password has already been executed: we already initialized it.
./result/bin/mysql --user=root   --socket $SOCKET_PATH < ./init_db.sql 

echo "Reading log at $DATA_PATH/$S_HOSTNAME.err"
cat $DATA_PATH/$S_HOSTNAME.err


