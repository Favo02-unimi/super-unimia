DROP SCHEMA unimia CASCADE;
CREATE SCHEMA unimia;

SET search_path TO unimia;

-- tipi di utenti possibili nel database
CREATE TYPE TIPO_UTENTE AS ENUM ('studente', 'docente', 'segretario');
