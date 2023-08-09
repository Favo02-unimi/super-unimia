SET search_path TO unimia;

-- crea un nuovo studente dato nome, cognome e password
CREATE OR REPLACE PROCEDURE new_studente (
  _nome TEXT,
  _cognome TEXT,
  _password TEXT
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _id uuid;
    BEGIN

      SET search_path TO unimia;

      INSERT INTO utenti(password, nome, cognome, tipo)
      VALUES (_password, _nome, _cognome, 'studente')
      RETURNING id INTO _id;

      INSERT INTO studenti(id)
      VALUES (_id);
      
    END;
  $$;

-- crea un nuovo docente dato nome, cognome e password
CREATE OR REPLACE PROCEDURE new_docente (
  _nome TEXT,
  _cognome TEXT,
  _password TEXT
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _id uuid;
    BEGIN

      SET search_path TO unimia;

      INSERT INTO utenti(password, nome, cognome, tipo)
      VALUES (_password, _nome, _cognome, 'docente')
      RETURNING id INTO _id;

      -- TODO: insert into docente
      INSERT INTO docenti(id)
      VALUES (_id);
      
    END;
  $$;

-- crea un nuovo segretario dato nome, cognome e password
CREATE OR REPLACE PROCEDURE new_segretario (
  _nome TEXT,
  _cognome TEXT,
  _password TEXT
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _id uuid;
    BEGIN

      SET search_path TO unimia;

      INSERT INTO utenti(password, nome, cognome, tipo)
      VALUES (_password, _nome, _cognome, 'segretario')
      RETURNING id INTO _id;

      -- TODO: insert into docente
      INSERT INTO segretari(id)
      VALUES (_id);
      
    END;
  $$;
