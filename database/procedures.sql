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
      VALUES (crypt(_password, gen_salt('bf')), INITCAP(_nome), INITCAP(_cognome), 'studente')
      RETURNING id INTO _id;

      INSERT INTO studenti(id)
      VALUES (_id);
      
    END;
  $$;

-- modifica uno studente dato il suo id
-- non vengono aggiornati i campi lasciati a NULL (coalesce)
CREATE OR REPLACE PROCEDURE edit_studente (
  _id uuid,
  _nome TEXT,
  _cognome TEXT,
  _email TEXT,
  _matricola CHAR(6)
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      UPDATE utenti SET
        nome = INITCAP(COALESCE(NULLIF(_nome, ''), nome)),
        cognome = INITCAP(COALESCE(NULLIF(_cognome, ''), cognome)),
        email = LOWER(COALESCE(NULLIF(_email, ''), email))
      WHERE id = _id;

      UPDATE studenti SET
        matricola = COALESCE(NULLIF(_matricola, ''), matricola)
      WHERE id = _id;

    END;
  $$;

-- elimina uno studente dato il suo id
-- l'utente non viene cancellato in caso siano presenti foreing key
CREATE OR REPLACE PROCEDURE delete_studente (
  _id uuid
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM studenti
      WHERE id = _id;

      DELETE FROM utenti
      WHERE id = _id;

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
      VALUES (crypt(_password, gen_salt('bf')), INITCAP(_nome), INITCAP(_cognome), 'docente')
      RETURNING id INTO _id;

      INSERT INTO docenti(id)
      VALUES (_id);
      
    END;
  $$;

-- modifica un docente dato il suo id
-- non vengono aggiornati i campi lasciati a NULL (coalesce)
CREATE OR REPLACE PROCEDURE edit_docente (
  _id uuid,
  _nome TEXT,
  _cognome TEXT,
  _email TEXT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      UPDATE utenti SET
        nome = INITCAP(COALESCE(NULLIF(_nome, ''), nome)),
        cognome = INITCAP(COALESCE(NULLIF(_cognome, ''), cognome)),
        email = LOWER(COALESCE(NULLIF(_email, ''), email))
      WHERE id = _id;

    END;
  $$;

-- elimina un docente dato il suo id
-- l'utente non viene cancellato in caso siano presenti foreing key
CREATE OR REPLACE PROCEDURE delete_docente (
  _id uuid
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM docenti
      WHERE id = _id;

      DELETE FROM utenti
      WHERE id = _id;

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
      VALUES (crypt(_password, gen_salt('bf')), INITCAP(_nome), INITCAP(_cognome), 'segretario')
      RETURNING id INTO _id;

      INSERT INTO segretari(id)
      VALUES (_id);
      
    END;
  $$;

-- modifica un segretario dato il suo id
-- non vengono aggiornati i campi lasciati a NULL (coalesce)
CREATE OR REPLACE PROCEDURE edit_segretario (
  _id uuid,
  _nome TEXT,
  _cognome TEXT,
  _email TEXT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      UPDATE utenti SET
        nome = INITCAP(COALESCE(NULLIF(_nome, ''), nome)),
        cognome = INITCAP(COALESCE(NULLIF(_cognome, ''), cognome)),
        email = LOWER(COALESCE(NULLIF(_email, ''), email))
      WHERE id = _id;

    END;
  $$;

-- elimina un segretario dato il suo id
-- l'utente non viene cancellato in caso siano presenti foreing key
CREATE OR REPLACE PROCEDURE delete_segretario (
  _id uuid
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM segretari
      WHERE id = _id;

      DELETE FROM utenti
      WHERE id = _id;

    END;
  $$;

-- modifica la password di un utente
CREATE OR REPLACE PROCEDURE edit_user_password (
  _email TEXT,
  _password TEXT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      UPDATE utenti SET
        password = crypt(_password, gen_salt('bf'))
      WHERE email = LOWER(_email);

    END;
  $$;
