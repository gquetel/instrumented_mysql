# Instrumented MySQL

This repository provides a Nix expression of a MySQL instrumented (by the GAUR tool) parser. The instrumented MySQL can be build using:

```
nix-build default.nix
```

The build phase possess two steps: the building of a custom bison (for which we simply add custom skeletons) and the building of MySQL on which we apply our custom [patch](./mysql/sql_yacc.patch) which replace the bison grammar, by an instrumented one.

## Bash scripts

We provide simple bash scripts to automatically initialize, start and kill and clean the instrumented MySQL server.
- [Initialization script](./init_mysql.sh) Initialize the database under `~/tmp/HOSTNAME/mysqld` (where HOSTNAME is the name of the machine) and with the datadir being located at `~/tmp/HOSTNAME/mysqld/datadir`.
- [Database start script](./start_mysql.sh) Starts the database on port 61337 and using a socket located at `~/tmp/HOSTNAME/mysqld/socket`. The first time the database is started, the script also run SQL queries from file [init_db.sql](./init_db.sql) required for our experience.
- [Database shutdown and directory cleaning](./kill_and_clean_mysql_files.sh) Attempt to retrieve PID of `mysqld` process using the socket and kill it. Also asks for removing `~/tmp/HOSTNAME/mysqld` directory. 

### Notes on scripts
- Option `--log-error` is necessary on computing machines, as otherwise mysql takes the /etc/mysql/...cnf configuration which tells it to write to a file it doesn't have access to, causing initialization to crash. By default, error logs will be printed in `datadir/hostname.err`.
- Option `--port 61337` is used as a mysqld is already running on the cluster machines, so a random port is provided.
