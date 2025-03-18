# Postgres

to restore db - remove dbdata folder, start a new pod
```sh
podman kube play postgres.yaml --configmap=configmap.yaml
```
pgbackrest will run in initContainer and restore if dbdata folder is empty

## Initial

su - postgres

psql
```sql
CREATE SCHEMA dbo (public already exists)

CREATE USER atle PASSWORD 'helloworld';
CREATE ROLE sa WITH LOGIN SUPERUSER PASSWORD 'password';
CREATE USER sa WITH SUPERUSER PASSWORD 'password';


GRANT ALL ON SCHEMA dbo TO atle;

GRANT ALL ON ALL TABLES IN SCHEMA dbo TO atle;
```
## new database and tables

```sql
CREATE DATABASE cln;
GRANT ALL ON SCHEMA public TO cln;
GRANT CREATE ON SCHEMA public TO cln;

CREATE TABLE TableTest 
    (ID int NOT NULL, 
    SomeValue varchar(50) NOT NULL

INSERT INTO TableTest (ID, SomeValue, AnotherValue)
VALUES (1, 'hello')

SELECT * from public.TableTest
```

## pgbackrest

ALL commands must be done via postgres user
```sh
su - postgres
```

### init

Remember postgres user must also own the backup folder stated in the config file

```sh
pgbackrest --config=/mnt/pgbackrest.conf stanza-create --stanza=main --log-level-console=info
# rm - usually we never do this
pgbackrest --config=/mnt/pgbackrest.conf --stanza=srv --log-level-console=info stop
pgbackrest --config=/mnt/pgbackrest.conf --stanza=srv --log-level-console=info stanza-delete

```

Remember set archive command in pgbackrest.conf

```conf
archive_command = 'pgbackrest --config=/mnt/pgbackrest.conf --stanza=main archive-push %p'
```

### check and test

check if values are correct

```sh
show wal_level; # replica
show archive_mode; #  on
show archive_command;
show max_wal_senders; # 10
show hot_standby; # on
```

Info: will show you status of all backups

```sh
pgbackrest --config=/mnt/pgbackrest.conf info
```

check to verify setup is ok

```sh
pgbackrest --config=/mnt/pgbackrest.conf --stanza=main --log-level-console=info check
```

### Actual backup

Now do a real backup. First time it will do a full, then incremental

```sh
pgbackrest --config=/mnt/pgbackrest.conf --stanza=main --log-level-console=info backup
```

### Restore 

postgres must not be running

```sh
pgbackrest --config=/mnt/pgbackrest.conf restore --stanza=main --log-level-console=info
```

## constr

### CLN
wallet=postgres://user:pass@localhost:5432/db_name

bookkeeper-db=

### LND

[db]
db.backend=postgres
[postgres]
 db.postgres.dsn=postgres://lnd:lnd@localhost:45432/lnd?sslmode=disable
 db.postgres.timeout=30s
 db.postgres.maxconnections=50