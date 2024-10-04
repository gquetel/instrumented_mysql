#!/bin/bash
DATA_PATH=/tmp/mysqld/datadir

# Check existence of /tmp/mysqld/datadir
if [ -d "$DATA_PATH" ]; then
  echo "Directory $DATA_PATH already exists... If you want to initialize the MySQL server, please remove the directory first."
  exit 1 
fi

mkdir -p /tmp/mysqld/datadir

./mysql/result/bin/mysqld   --datadir /tmp/mysqld/datadir --initialize-insecure
./mysql/result/bin/mysqld --socket /tmp/mysqld/socket --datadir /tmp/mysqld/datadir