#!/bin/bash
S_HOSTNAME=$(hostname -s)
PREFIX=~/tmp/$S_HOSTNAME/mysqld

DATA_PATH=$PREFIX/datadir
SOCKET_PATH=$PREFIX/socket
BASEDIR=./result/bin

# Check existence of /tmp/mysqld/datadir

if [ -d "$DATA_PATH" ]; then
  echo "Directory $DATA_PATH already exists. If you want to reinitialize the MySQL server, remove the directory."
else
    mkdir -p $DATA_PATH
    ./result/bin/mysqld --log-error --basedir=$BASEDIR  --datadir $DATA_PATH --initialize-insecure
fi
echo "Reading log at $DATA_PATH/$S_HOSTNAME.err"
cat $DATA_PATH/$S_HOSTNAME.err
