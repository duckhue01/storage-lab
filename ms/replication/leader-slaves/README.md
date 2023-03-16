## Create mysql container with configuration file 

```bash
docker run --name mysql-with-cnf -v /Users/duckhue01/code/learn/sto/ms/leader-slaves/leader.cnf:/etc/mysql/conf.d/leader.cnf -e MYSQL_ROOT_PASSWORD=root -dp 3306:3306 mysql:latest
```
  
## Setting up replication

### Set up replication accounts on each server.
```sql
CREATE USER 'repl'@'%' IDENTIFIED BY 'repl';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.*  TO 'repl'@'%';
```


### Configure the master and replica.

leader configuration:
```cnf
log_bin = mysql-bin 
server_id = 10
```

slave configuration:
```cnf
log_bin = mysql-bin
server_id = 2
relay_log = /var/lib/mysql/mysql-relay-bin
log_slave_updates = 1
read_only = 1
```

### Instruct the replica to connect to and replicate from the master.

```sql
CHANGE REPLICATION SOURCE TO
MASTER_HOST='host.docker.internal', 
MASTER_USER='repl',
MASTER_PASSWORD='repl',
MASTER_LOG_FILE='mysql-bin.000003',
MASTER_LOG_POS=0;
```