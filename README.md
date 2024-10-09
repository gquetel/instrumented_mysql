# Instrumented MySQL

This repository provides a Nix expression of a MySQL instrumented (by the GAUR tool) parser. The instrumented MySQL can be build using:

```
nix-build default.nix
```

The build phase possess two steps: the building of a custom bison (for which we simply add custom skeletons) and the building of MySQL on which we apply our custom [patch](./mysql/sql_yacc.patch) which replace the bison grammar, by an instrumented one.

## Bash scripts

We provide simple bash scripts to automatically initialize, start and kill and clean instrumented MySQL servers. The first two scripts takes as argument an integer (between 1 and 30) which corresponds to the number of instrumented MySQL server to initialize / start.

- [Initialization script](./init_mysql.sh) Require an argument i, corresponding to the number of instrumented servers to initalize. Each server files are located under `~/tmp/HOSTNAME/mysqld_i` (where HOSTNAME is the name, and i the number of the server). The datadir of the server will be located at `~/tmp/HOSTNAME/mysqld_i/datadir`.
- [Database start script](./start_mysql.sh) Require an argument i, corresponding to the number of instrumented servers to start. Each server uses the port 61337+i and a socket located at `~/tmp/HOSTNAME/mysqld_i/socket`. The first time the database is started, the script also run SQL queries from file [init_db.sql](./init_db.sql) required for our experience.
- [Database shutdown and directory cleaning](./kill_and_clean_mysql_files.sh) Attempt to retrieve PIDs of our `mysqld` processes and kill them. Also asks for removing all files under the `~/tmp/HOSTNAME/` directory. 

### Notes on scripts
- Option `--log-error` is necessary on computing machines, as otherwise mysql takes the /etc/mysql/...cnf configuration which tells it to write to a file it doesn't have access to, causing initialization to crash. By default, error logs will be printed in `datadir/hostname.err`.
- Option `--port 61337` is used as a mysqld is already running on the cluster machines, so a random port is provided.
