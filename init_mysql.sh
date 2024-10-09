#!/bin/bash
S_HOSTNAME=$(hostname -s)
PREFIX=~/tmp/$S_HOSTNAME/mysqld
BASEDIR=./result/bin

if [ $# -ne 1 ]; then
  echo "Usage: $0 <number of MySQL servers to initialize>"
  exit 1
fi

if [ $1 -lt 1 ] || [ $1 -gt 30 ]; then
  echo "Number of MySQL servers should be between 1 and 30 (what madlad would want more than 30 ?)"
  exit 1
fi

echo "Initializing $1 MySQL servers..."
# Iterate over the number of MySQL servers to be started
for i in $(seq 1 $1); do
  # Each folder will be named mysqld_i where i is the index of the MySQL server
  echo "Initializing MySQL server $i."
  DATA_PATH=$PREFIX"_"$i"/datadir"
  if [ -d "$DATA_PATH" ]; then
    echo "Directory $DATA_PATH already exists. If you want to reinitialize the MySQL server, remove the directory."
  else
    mkdir -p $DATA_PATH
    $BASEDIR/mysqld --log-error  --initialize-insecure --basedir=$BASEDIR --datadir=$DATA_PATH
  fi
  echo "Reading log at $DATA_PATH/$S_HOSTNAME.err"
  cat $DATA_PATH/$S_HOSTNAME.err
done