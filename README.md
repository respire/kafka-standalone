## kafka standalone
get tired of docker/k8s for small deployment? boot your kafka standalone cluster in traditional way!

|    Module     |    Introduction    |
|---------------|--------------------|
| [kafka 2.1.1](https://kafka.apache.org/) | stream stroage |
| [ruby 2.5.5 + eye 0.10](https://github.com/kostya/eye)    | process monitoring |
| [maxwell 1.2.0](http://maxwells-daemon.io/) | lightweight MYSQL CDC (yep, i don't like kafka-connect and kafka-stream for small volume case)          |

### setup
```
bundle install
./bin/leye load
```

### info
```
./bin/leye info
```

### start
```
./bin/leye start all
```

#### stop
```
./bin/leye stop all
```

### HOW TO: configure maxwell for mysql 5.7.x
1. edit my.cnf (in most cases, /etc/mysql/mysql.conf.d/mysqld.conf)
```
server-id                    = 1
log_bin                      = mysql-bin
binlog_format                = row
binlog_row_image             = full
expire_logs_days             = 10
max_binlog_size              = 1G
log_slave_updates            = ON
gtid_mode                    = ON
enforce_gtid_consistency     = ON
binlog_rows_query_log_events = ON
```
2. restart mysql server
3. ```sudo mysql -u root```
4. execute script to create user and tables for maxwell.
```.sql
CREATE USER 'maxwell'@'localhost' IDENTIFIED BY 'maxwell';
GRANT ALL ON maxwell.* TO 'maxwell'@'localhost';
GRANT SELECT, REPLICATION CLIENT, REPLICATION SLAVE ON *.* TO 'maxwell'@'localhost';
```
5. you can start maxwell now
6. if you want to bootstrap tables, execute following script for each table
```.sql
INSERT INTO maxwell.boostrap(database_name, table_name) values ('DATABASE_TO_BOOTSTRAP', 'TABLE_TO_BOOTSTRAP');
```
