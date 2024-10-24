#!/bin/bash
S_HOSTNAME=$(hostname -s)
PREFIX=~/tmp/$S_HOSTNAME/mysqld
BASEDIR=./result/bin

if [ $# -lt 1 ]; then
  echo "Usage: $0 <number of MySQL servers to initialize> [path to configuration file]"
  exit 1
fi

# Check existence of second argument which is a path to a configuration file and is optional and check if it is a file
if [ -n "$2" ]; then
  if [ ! -f $2 ]; then
    echo "Configuration file $2 does not exist."
    exit 1
  fi
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
    # If a configuration file was provided, use it
    if [ -n "$2" ]; then
      $BASEDIR/mysqld --defaults-file=$2 --log-error=$DATA_PATH/$S_HOSTNAME.err --initialize-insecure --basedir=$BASEDIR --datadir=$DATA_PATH
    else
      $BASEDIR/mysqld --log-error=$DATA_PATH/$S_HOSTNAME.err --initialize-insecure --basedir=$BASEDIR --datadir=$DATA_PATH
    fi
  fi
  echo "Reading log at $DATA_PATH/$S_HOSTNAME.err"
  cat $DATA_PATH/$S_HOSTNAME.err
done