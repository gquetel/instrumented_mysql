#!/bin/bash

mkdir -p _mysql_files/data
./mysql/result/bin/mysqld  --initialize-insecure --datadir=./_mysql_files/data/
./mysql/result/bin/mysqld --datadir=./_mysql_files/data/ --socket=./_mysql_files/mysql.sock 