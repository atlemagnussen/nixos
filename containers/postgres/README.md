# Postgres

podman kube play --configmap=configmap.yaml postgres.yaml

## Initial

su - postgres

psql

CREATE SCHEMA dbo (public already exists)

CREATE USER atle PASSWORD 'helloworld';
CREATE ROLE sa WITH LOGIN SUPERUSER PASSWORD 'password';
CREATE USER sa WITH SUPERUSER PASSWORD 'password';


GRANT ALL ON SCHEMA dbo TO atle;

GRANT ALL ON ALL TABLES IN SCHEMA dbo TO atle;

## new database and tables

CREATE DATABASE postgrelearning;

CREATE TABLE TableTest1 
    (ID int NOT NULL, 
    SomeValue varchar(50) NOT NULL, 
    AnotherValue varchar(30) NULL);

INSERT INTO TableTest1 (ID, SomeValue, AnotherValue)
VALUES (1, 'hello', 'world')

SELECT * from public.TableTest1

## pgbackrest

su - postgres

init as postgres user, must also own the backup folder stated in the config file
```sh
pgbackrest --config=/mnt/pgbackrest.conf stanza-create --stanza=srv --log-level-console=info
```
set archive command in pgbackrest.conf
```sh
pgbackrest --config=/mnt/pgbackrest.conf --stanza=srv archive-push %p
```

test
```sh
show wal_level;
show archive_mode;
show archive_command;
show max_wal_senders;
show hot_standby;
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