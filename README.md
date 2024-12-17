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
- On some of the cluster machines I am running my experiments on, SQL servers are already running. When launching the instrumented one, `mysqld` is fetching the global configuration file, which we don't want. Therefore on the [Initialization script](./init_mysql.sh) and the [Database start script](./start_mysql.sh) you can specify, as a second argument a path to a configuration file (passed to mysqld through the option [defaults-file](https://dev.mysql.com/doc/refman/8.4/en/option-file-options.html#option_general_defaults-file)) to use instead of the defaults one.
- Option `--log-error` is necessary in scripts ran on cluster machines as the default configuration tells the instrumented mysql server to write logs to a path I do not have access to, causing initialization to crash. By default, error logs will be printed in `datadir/hostname.err`.
- Option `--port N` is used as multiple process can be running on the cluster machines, so a random port is provided.
- [Initialization script](./init_mysql.sh) Require an argument i, corresponding to the number of instrumented servers to initalize. Each server files are located under `~/tmp/HOSTNAME/mysqld_i` (where HOSTNAME is the name, and i the number of the server). The datadir of the server will be located at `~/tmp/HOSTNAME/mysqld_i/datadir`.
- [Database start script](./start_mysql.sh) Require an argument i, corresponding to the number of instrumented servers to start. Each server uses the port 61337+i and a socket located at `~/tmp/HOSTNAME/mysqld_i/socket`. The first time the database is started, the script also run SQL queries from file [init_db.sql](./init_db.sql) required for our experience.
- [Database shutdown and directory cleaning](./kill_and_clean_mysql_files.sh) Attempt to retrieve PIDs of our `mysqld` processes and kill them. Also asks for removing all files under the `~/tmp/HOSTNAME/` directory. 