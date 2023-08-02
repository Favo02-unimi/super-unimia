DROP SCHEMA unimia CASCADE;

CREATE SCHEMA unimia;

CREATE TABLE unimia.utenti (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL UNIQUE CHECK (email ~* '^[A-Za-z0-9._%-]+@(studenti|docenti|segretari).superuni.it$'),
  password TEXT NOT NULL,
  nome TEXT NOT NULL CHECK (nome ~* '^.+$'),
  cognome TEXT NOT NULL CHECK (cognome ~* '^.+$')
);

CREATE TABLE unimia.studenti (
  id uuid REFERENCES unimia.utenti(id),
  matricola CHAR(6) NOT NULL UNIQUE CHECK (matricola ~* '^\d{6}$')
);

CREATE TABLE unimia.docenti (
  id uuid REFERENCES unimia.utenti(id)
);

CREATE TABLE unimia.segretari (
  id uuid REFERENCES unimia.utenti(id)
);
