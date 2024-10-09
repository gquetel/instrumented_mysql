#!/bin/bash
S_HOSTNAME=$(hostname -s)
PREFIX=~/tmp/$S_HOSTNAME/mysqld

DELETE_DIRS=0 # Do not delete by default

# Find PIDs of process using the PREFIX path and the --daemonize flag, i.e., the MySQL servers
PID=$(ps -aux | grep $PREFIX | grep "daemonize" | awk '{print $2}')

# Check if results, if not, asks if the user wants to remove the directories
if [ -z "$PID" ]; then
  echo "No MySQL server seems to be running."
  exit 1  
else
  read -p "Do you want to remove the mysqld directories? [y/n] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf $PREFIX"*"
  fi
fi
  
# Iterate over the PIDs
for p in $PID; do
  # Get the command that started the process
  COMM=$(cat /proc/${p}/comm)
  # If comm is mysqld, kill the process
  if [ "$COMM" == "mysqld" ]; then
    kill -9 $p
    echo "Killed process with PID $p"
    # Also clean error files:
    rm -f $PREFIX"_"$i"/datadir/$S_HOSTNAME.err"
  else
    echo "The process with PID $p is not mysqld ($COMM)."
  fi
done