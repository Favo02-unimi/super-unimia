DROP SCHEMA IF EXISTS unimia CASCADE;
CREATE SCHEMA unimia;

SET search_path TO unimia;

-- estensione per l'hashing delle password
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- tipi di utenti possibili nel database
CREATE TYPE TIPO_UTENTE AS ENUM ('studente', 'docente', 'segretario', 'ex_studente');

-- tipi di corsi di laurea disponibili
CREATE TYPE TIPO_LAUREA AS ENUM ('Triennale', 'Magistrale', 'Magistrale a ciclo unico');

-- anni di un insegnamento validi (verrà controllato anche in base al tipo di corso di laurea)
CREATE TYPE ANNO_INSEGNAMENTO AS ENUM ('1', '2', '3', '4', '5');

-- motivazione dell'archiviazione di uno studente
CREATE TYPE MOTIVAZIONE_ARCHIVIO AS ENUM ('Rinuncia agli studi', 'Laurea');
