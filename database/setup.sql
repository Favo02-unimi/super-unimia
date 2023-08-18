DROP SCHEMA unimia CASCADE;
CREATE SCHEMA unimia;

SET search_path TO unimia;

-- estensione per l'hashing delle password
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- tipi di utenti possibili nel database
CREATE TYPE TIPO_UTENTE AS ENUM ('studente', 'docente', 'segretario');
