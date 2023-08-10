SET search_path TO unimia;

CREATE TABLE utenti (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  password TEXT NOT NULL CHECK (password ~ '^.{8,}$'),
  nome TEXT NOT NULL CHECK (nome ~* '^.+$'),
  cognome TEXT NOT NULL CHECK (cognome ~* '^.+$'),
  tipo TIPO_UTENTE NOT NULL,
  email TEXT NOT NULL UNIQUE CHECK (email ~* '^[A-Za-z0-9._%-]+@(studente|docente|segretario).superuni.it$')
);

CREATE TABLE studenti (
  id uuid REFERENCES utenti(id),
  matricola CHAR(6) NOT NULL UNIQUE CHECK (matricola ~* '^\d{6}$')
);

CREATE TABLE docenti (
  id uuid REFERENCES utenti(id)
);

CREATE TABLE segretari (
  id uuid REFERENCES utenti(id)
);
