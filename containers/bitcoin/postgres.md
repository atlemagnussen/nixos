# Postgres

## Initial

su - postgres

psql

CREATE SCHEMA dbo (public already exists)

CREATE USER atle PASSWORD 'helloworld';

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