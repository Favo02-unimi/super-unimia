SET search_path TO unimia;

-- verifica il login di un utente data email e password
-- restituisce id e tipo dell'utente in caso di login corretto
CREATE OR REPLACE FUNCTION login (
  _email TEXT,
  _password TEXT
)
  RETURNS TABLE (
    __id uuid,
    __type TIPO_UTENTE
  )
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.tipo
        FROM utenti AS u
        WHERE u.email = _email
        AND u.password is NOT NULL 
        AND u.password = crypt(_password, u.password);

    END;
  $$;

-- restituisce tutti gli studenti disponibili
CREATE OR REPLACE FUNCTION get_studenti ()
  RETURNS TABLE (
    __id uuid,
    __nome TEXT,
    __cognome TEXT,
    __email TEXT,
    __matricola CHAR(6)
  )
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email, s.matricola
        FROM studenti AS s
        INNER JOIN utenti AS u ON u.id = s.id;

    END;
  $$;

-- restituisce tutti i docenti disponibili
CREATE OR REPLACE FUNCTION get_docenti ()
  RETURNS TABLE (
    __id uuid,
    __nome TEXT,
    __cognome TEXT,
    __email TEXT
  )
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email
        FROM docenti AS d
        INNER JOIN utenti AS u ON u.id = d.id;

    END;
  $$;

-- restituisce tutti i segretari disponibili
CREATE OR REPLACE FUNCTION get_segretari ()
  RETURNS TABLE (
    __id uuid,
    __nome TEXT,
    __cognome TEXT,
    __email TEXT
  )
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email
        FROM segretari AS s
        INNER JOIN utenti AS u ON u.id = s.id;

    END;
  $$;

-- restituisce tutti i corsi di laurea
CREATE OR REPLACE FUNCTION get_corsi_di_laurea ()
  RETURNS TABLE (
    __codice VARCHAR(6),
    __tipo TIPO_LAUREA,
    __nome TEXT,
    __descrizione TEXT
  )
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT c.codice, c.tipo, c.nome, c.descrizione
        FROM corsi_di_laurea AS c;

    END;
  $$;
