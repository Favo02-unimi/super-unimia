SET search_path TO unimia;

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

      -- TODO: insert into studente
      -- INSERT INTO studenti(id, matricola)
      -- VALUES (_id, '000002');
      
    END;
  $$;
