DROP SCHEMA unimia CASCADE;
CREATE SCHEMA unimia;

SET search_path TO unimia;

-- estensione per l'hashing delle password
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- tipi di utenti possibili nel database
CREATE TYPE TIPO_UTENTE AS ENUM ('studente', 'docente', 'segretario');

CREATE TYPE TIPO_LAUREA AS ENUM ('Triennale', 'Magistrale', 'Magistrale a ciclo unico');

CREATE TYPE ANNO_INSEGNAMENTO AS ENUM ('1', '2', '3', '4', '5');
