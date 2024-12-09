#!/bin/sh
S_HOSTNAME=$(hostname -s)
PREFIX=~/tmp/$S_HOSTNAME/mysqld
BASEDIR=./result/bin

if [ $# -lt 1 ]; then
  echo "Usage: $0 <number of MySQL servers to start> [path to configuration file]"
  exit 1
fi

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

echo "Starting $1 MySQL servers..."

for i in $(seq 1 $1); do
    PARENT_DIR=$PREFIX"_"$i
    DATA_PATH=$PARENT_DIR"/datadir"
    SOCKET_PATH=$PARENT_DIR"/socket"
    PORT=$((61336 + $i))

    if [ -d "$PARENT_DIR" ]; then
        echo "Starting MySQL server $i, using datadir $DATA_PATH, socket $SOCKET_PATH, and port $PORT."
        if [ -n "$2" ]; then
            ./result/bin/mysqld --defaults-file=$2 --log-error --basedir=$BASEDIR --socket $SOCKET_PATH --datadir $DATA_PATH --port $PORT --daemonize 
        else
            ./result/bin/mysqld --log-error --basedir=$BASEDIR --socket $SOCKET_PATH --datadir $DATA_PATH --port $PORT --daemonize 
        fi
        
        sleep 5 # Wait for the server to start  
        # # If the connection doesn't succeed, it means root password has already been executed: we already initialized it.
        ./result/bin/mysql --user=root   --socket $SOCKET_PATH < ./init_db.sql 
        echo "Reading log at $DATA_PATH/$S_HOSTNAME.err"
        cat $DATA_PATH/$S_HOSTNAME.err
    else
        echo "Directory $PARENT_DIR does not exist. Please run init_mysql.sh first."
        exit 1
    fi
done