#!/bin/bash
DATA_PATH=/tmp/mysqld/datadir
SOCKET_PATH=/tmp/mysqld/socket
# Check existence of /tmp/mysqld/datadir
if [ -d "$DATA_PATH" ]; then
  echo "Directory $DATA_PATH already exists... If you want to initialize the MySQL server, please remove the directory first."
else
    mkdir -p /tmp/mysqld/datadir
    ./mysql/result/bin/mysqld   --datadir /tmp/mysqld/datadir --initialize-insecure
fi

./mysql/result/bin/mysqld --socket $SOCKET_PATH --datadir /tmp/mysqld/datadir 