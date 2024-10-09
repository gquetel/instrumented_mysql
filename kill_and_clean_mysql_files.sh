#!/bin/bash
S_HOSTNAME=$(hostname -s)
PREFIX=~/tmp/$S_HOSTNAME/mysqld

SOCKET_PATH=$PREFIX/socket
DATA_PATH=$PREFIX/datadir

# Find PID of process which is using the socket, only print first line 
PID=$(ps -aux | grep $SOCKET_PATH | awk '{print $2}' | head -n 1)
COMM=$(cat /proc/${PID}/comm)

# If comm is mysqld, kill the process
if [ "$COMM" == "mysqld" ]; then
  echo "Killing process with PID $PID"
  kill -9 $PID
else
  echo "No process seems to be using the socket."
fi

read -p "Do you want to remove the directory $DATA_PATH? [y/n] " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -rf $DATA_PATH
fi
