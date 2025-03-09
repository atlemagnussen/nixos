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

pgbackrest stanza-create --stanza=atle --log-level-console=info

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