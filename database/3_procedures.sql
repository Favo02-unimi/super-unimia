SET search_path TO unimia;

-- crea un nuovo studente dato nome, cognome e password
CREATE OR REPLACE PROCEDURE new_studente (
  _nome TEXT,
  _cognome TEXT,
  _password TEXT,
  _corso_di_laurea VARCHAR(6)
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _id uuid;
    BEGIN

      SET search_path TO unimia;

      INSERT INTO utenti(password, nome, cognome, tipo)
      VALUES (crypt(_password, gen_salt('bf')), INITCAP(_nome), INITCAP(_cognome), 'studente')
      RETURNING id INTO _id;

      INSERT INTO studenti(id, corso_di_laurea)
      VALUES (_id, _corso_di_laurea);
      
    END;
  $$;

-- modifica uno studente dato il suo id
-- non vengono aggiornati i campi lasciati a NULL (coalesce)
CREATE OR REPLACE PROCEDURE edit_studente (
  _id uuid,
  _nome TEXT,
  _cognome TEXT,
  _email TEXT,
  _matricola CHAR(6),
  _corso_di_laurea VARCHAR(6)
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
        matricola = COALESCE(NULLIF(_matricola, ''), matricola),
        corso_di_laurea = _corso_di_laurea
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

-- modifica la password di un utente (data solo la mail, senza controlli, quindi per un admin)
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
      IF NOT FOUND THEN
        raise exception 'Utente non trovato'; 
      END IF;

    END;
  $$;

-- modifica la password di un utente (dato l'id e la vecchia password, quindi per utenti semplici)
CREATE OR REPLACE PROCEDURE edit_password (
  _id uuid,
  _old_password TEXT,
  _password TEXT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN
      SET search_path TO unimia;

      UPDATE utenti SET
        password = crypt(_password, gen_salt('bf'))
      WHERE id = _id
      AND password = crypt(_old_password, password);
      IF NOT FOUND THEN
        raise exception 'Vecchia password errata'; 
      END IF;

    END;
  $$;

-- crea un nuovo corso di laurea
CREATE OR REPLACE PROCEDURE new_corso_di_laurea (
  _codice VARCHAR(6),
  _tipo TIPO_LAUREA,
  _nome TEXT,
  _descrizione TEXT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      INSERT INTO corsi_di_laurea(codice, tipo, nome, descrizione)
      VALUES (_codice, _tipo, _nome, _descrizione);

    END;
  $$;

-- modifica un corso di laurea dato il suo codice
-- non vengono aggiornati i campi lasciati a NULL (coalesce)
CREATE OR REPLACE PROCEDURE edit_corso_di_laurea (
  _codice VARCHAR(6),
  _new_codice VARCHAR(6),
  _tipo TIPO_LAUREA,
  _nome TEXT,
  _descrizione TEXT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      UPDATE corsi_di_laurea SET
        codice = COALESCE(NULLIF(_new_codice, ''), codice),
        tipo = _tipo,
        nome = COALESCE(NULLIF(_nome, ''), nome),
        descrizione = COALESCE(NULLIF(_descrizione, ''), descrizione)
      WHERE codice = _codice;

    END;
  $$;

-- elimina un corso di laurea dato il suo codice
-- il cdl non viene cancellato in caso siano presenti foreing key
CREATE OR REPLACE PROCEDURE delete_corso_di_laurea (
  _codice VARCHAR(6)
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM corsi_di_laurea
      WHERE codice = _codice;

    END;
  $$;

-- crea un nuovo insegnamento
CREATE OR REPLACE PROCEDURE new_insegnamento (
  _codice VARCHAR(6),
  _corso_di_laurea VARCHAR(6),
  _nome TEXT,
  _descrizione TEXT,
  _anno ANNO_INSEGNAMENTO,
  _responsabile uuid,
  _propedeuiticita VARCHAR(6)[]
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _propedeutico VARCHAR(6);
    BEGIN

      SET search_path TO unimia;

      INSERT INTO insegnamenti(codice, corso_di_laurea, nome, descrizione, anno, responsabile)
      VALUES (_codice, _corso_di_laurea, _nome, _descrizione, _anno, _responsabile);

      IF _propedeuiticita IS NOT NULL THEN
        FOREACH _propedeutico IN ARRAY _propedeuiticita LOOP
          INSERT INTO propedeuticita VALUES (_codice, _propedeutico);
        END LOOP;
      END IF;

    END;
  $$;

-- modifica un insegnamento dato il suo codice
-- non vengono aggiornati i campi lasciati a NULL (coalesce)
CREATE OR REPLACE PROCEDURE edit_insegnamento (
  _codice VARCHAR(6),
  _new_codice VARCHAR(6),
  _corso_di_laurea VARCHAR(6),
  _nome TEXT,
  _descrizione TEXT,
  _anno ANNO_INSEGNAMENTO,
  _responsabile uuid,
  _propedeuiticita VARCHAR(6)[]
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _propedeutico VARCHAR(6);
    BEGIN

      SET search_path TO unimia;

      UPDATE insegnamenti SET
        codice = COALESCE(NULLIF(_new_codice, ''), codice),
        corso_di_laurea = _corso_di_laurea,
        nome = COALESCE(NULLIF(_nome, ''), nome),
        descrizione = COALESCE(NULLIF(_descrizione, ''), descrizione),
        anno = _anno,
        responsabile = _responsabile
      WHERE codice = _codice;

      DELETE FROM propedeuticita AS p
      WHERE p.insegnamento = _codice;

      IF _propedeuiticita IS NOT NULL THEN
        FOREACH _propedeutico IN ARRAY _propedeuiticita LOOP
          INSERT INTO propedeuticita VALUES (COALESCE(NULLIF(_new_codice, ''), _codice), _propedeutico);
        END LOOP;
      END IF;

    END;
  $$;

-- elimina un insegnamento dato il suo codice
-- l'insegnamento non viene cancellato in caso siano presenti foreing key
CREATE OR REPLACE PROCEDURE delete_insegnamento (
  _codice VARCHAR(6)
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM insegnamenti
      WHERE codice = _codice;

    END;
  $$;

-- crea un appello
CREATE OR REPLACE PROCEDURE new_appello (
  _insegnamento VARCHAR(6),
  _data DATE,
  _ora TIME,
  _luogo TEXT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      IF Now() > _data THEN
        raise exception E'L\'appello non deve essere nel passato';
      END IF;

      INSERT INTO appelli(insegnamento, data, ora, luogo)
      VALUES (_insegnamento, _data, _ora, _luogo);

    END;
  $$;

-- modifica un appello dato il suo codice
CREATE OR REPLACE PROCEDURE edit_appello (
  _codice uuid,
  _data DATE,
  _ora TIME,
  _luogo TEXT
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _old_data DATE;
    BEGIN

      SET search_path TO unimia;

      SELECT data INTO _old_data FROM appelli WHERE codice = _codice;

      IF Now() > _old_data THEN
        raise exception E'L\'appello è passato, non può essere modificato';
      END IF;

      IF Now() > _data THEN
        raise exception E'L\'appello non deve essere nel passato';
      END IF;

      UPDATE appelli SET
        data = _data,
        ora = _ora,
        luogo = _luogo
      WHERE codice = _codice;

    END;
  $$;

-- elimina un appello dato il suo codice
-- l'appello non viene cancellato in caso siano presenti foreing key
CREATE OR REPLACE PROCEDURE delete_appello (
  _codice uuid
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM appelli
      WHERE codice = _codice;

    END;
  $$;

-- iscrivere uno studente ad un appello
CREATE OR REPLACE PROCEDURE iscriviti_appello (
  _id uuid,
  _codice uuid
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      INSERT INTO iscrizioni VALUES(_codice, _id, NULL);

    END;
  $$;

-- disiscrivere uno studente ad un appello
CREATE OR REPLACE PROCEDURE disiscriviti_appello (
  _id uuid,
  _codice uuid
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM iscrizioni AS i WHERE i.appello = _codice AND i.studente = _id;

    END;
  $$;

-- valuta uno studente iscritto ad un appello
CREATE OR REPLACE PROCEDURE valuta_iscrizione (
  _id uuid,
  _codice uuid,
  _voto INTEGER
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _data DATE;
    BEGIN

      SET search_path TO unimia;

      SELECT a.data INTO _data
      FROM appelli AS a
      WHERE a.codice = _codice;

      IF _data > Now() THEN
        raise exception E'L\'appello da valutare deve essere passato';
      END IF;

      UPDATE iscrizioni AS i SET
        voto = _voto
      WHERE i.appello = _codice
      AND i.studente = _id;

    END;
  $$;
