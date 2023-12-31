SET search_path TO unimia;

-- genera la mail dell'utente basandosi su nome, cognome, tipo e omonimi
CREATE OR REPLACE FUNCTION genera_mail_func()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
    DECLARE _num INTEGER;
    BEGIN

      SET search_path TO unimia;

      SELECT count(*) INTO _num
      FROM utenti AS u
      WHERE u.email LIKE CONCAT(LOWER(NEW.nome), '.', LOWER(NEW.cognome), '%');

      IF _num = 0 THEN
        NEW.email := CONCAT(LOWER(NEW.nome), '.', LOWER(NEW.cognome), '@', NEW.tipo, '.superuni.it');
      ELSE
        NEW.email := CONCAT(LOWER(NEW.nome), '.', LOWER(NEW.cognome), _num, '@', NEW.tipo, '.superuni.it');
      END if;

      RETURN NEW;

    END;
  $$;
CREATE OR REPLACE TRIGGER genera_mail 
  BEFORE INSERT
  ON utenti
  FOR EACH ROW
  EXECUTE PROCEDURE genera_mail_func();

-- genera la matricola dello studente (controllando eventuali duplicati)
CREATE OR REPLACE FUNCTION genera_matricola_func()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
    DECLARE _matricola CHAR(6);
    BEGIN

      SET search_path TO unimia;

      LOOP
        _matricola := floor(random() * (999999 - 100000 + 1) + 100000)::CHAR(6);

        IF NOT EXISTS (
          SELECT matricola FROM studenti WHERE matricola = _matricola
        ) THEN
          NEW.matricola := _matricola;
          EXIT;
        END IF;
      END LOOP;

      RETURN NEW;

    END;
  $$;
CREATE OR REPLACE TRIGGER genera_matricola 
  BEFORE INSERT
  ON studenti
  FOR EACH ROW
  EXECUTE PROCEDURE genera_matricola_func();

-- controlla alla creazione di un nuovo insegnamento che l'anno sia compatibile con il tipo di laurea
CREATE OR REPLACE FUNCTION controllo_anno_insegnamento_func()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
    DECLARE _tipo_corso TEXT;
    BEGIN

      SET search_path TO unimia;

      SELECT cdl.tipo
      FROM corsi_di_laurea AS cdl
      WHERE cdl.codice = NEW.corso_di_laurea
      INTO _tipo_corso;

      IF _tipo_corso = 'Triennale' AND NEW.anno IN ('4', '5') THEN
        RAISE EXCEPTION 'Anno invalido per corso triennale';
      END IF;

      IF _tipo_corso = 'Magistrale' AND NEW.anno IN ('3', '4', '5') THEN
        RAISE EXCEPTION 'Anno invalido per corso magistrale';
      END IF;

      RETURN NEW;

    END;
  $$;
CREATE OR REPLACE TRIGGER controllo_anno_insegnamento 
  BEFORE INSERT OR UPDATE
  ON insegnamenti
  FOR EACH ROW
  EXECUTE PROCEDURE controllo_anno_insegnamento_func();

-- controlla alla creazione di un nuovo insegnamento che il responsabile non abbia già 3 insegnamenti
CREATE OR REPLACE FUNCTION controllo_numero_insegnamenti_per_docente_func()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
    DECLARE _numero_insegnamenti INTEGER;
    BEGIN

      SET search_path TO unimia;

      SELECT count(*)
      FROM insegnamenti AS i
      WHERE i.responsabile = NEW.responsabile
      AND i.codice != NEW.codice
      INTO _numero_insegnamenti;

      IF _numero_insegnamenti >= 3 THEN
        RAISE EXCEPTION 'Responsabile ha già 3 insegnamenti';
      END IF;

      RETURN NEW;

    END;
  $$;
CREATE OR REPLACE TRIGGER controllo_numero_insegnamenti_per_docente 
  BEFORE INSERT OR UPDATE
  ON insegnamenti
  FOR EACH ROW
  EXECUTE PROCEDURE controllo_numero_insegnamenti_per_docente_func();

-- controlla che le propedeuticità non siano cicliche
CREATE OR REPLACE FUNCTION controllo_propedeuticita_cicliche_func()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
    DECLARE _c INTEGER;
    BEGIN

      SET search_path TO unimia;

      IF NEW.insegnamento_propedeutico = NEW.insegnamento THEN
        raise exception 'È presente una propedeuticità ciclica';
      END IF;

      WITH RECURSIVE propedeutici AS (
          -- non-recursive term
          SELECT p.insegnamento_propedeutico
          FROM propedeuticita AS p
          WHERE insegnamento = NEW.insegnamento_propedeutico
        UNION
          -- recursive term
          SELECT p2.insegnamento_propedeutico
          FROM propedeutici AS p
          INNER JOIN propedeuticita AS p2 ON p.insegnamento_propedeutico = p2.insegnamento
      )
      SELECT count(*) INTO _c FROM propedeutici AS p
      WHERE p.insegnamento_propedeutico = NEW.insegnamento;

      IF _c > 0 THEN
        raise exception 'È presente una propedeuticità ciclica';
      END IF;

      RETURN NEW;

    END;
  $$;
CREATE OR REPLACE TRIGGER controllo_propedeuticita_cicliche
  BEFORE INSERT OR UPDATE
  ON propedeuticita
  FOR EACH ROW
  EXECUTE PROCEDURE controllo_propedeuticita_cicliche_func();

-- controlla che non esistano più appelli dello corso di laurea nella stessa giornata
CREATE OR REPLACE FUNCTION controllo_appelli_per_anno_func()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
    DECLARE _anno ANNO_INSEGNAMENTO;
    DECLARE _cdl VARCHAR(6);
    DECLARE _appelli INTEGER;
    BEGIN

      SET search_path TO unimia;

      SELECT i.anno, i.corso_di_laurea INTO _anno, _cdl
      FROM insegnamenti AS i
      WHERE i.codice = NEW.insegnamento;

      SELECT count(*) INTO _appelli
      FROM appelli AS a
      INNER JOIN insegnamenti AS i ON i.codice = a.insegnamento
      WHERE i.corso_di_laurea = _cdl
      AND i.anno = _anno
      AND a.data = NEW.data
      AND a.codice != NEW.codice;

      IF _appelli >= 1 THEN
        RAISE EXCEPTION 'Sono già presenti appelli in questa giornata';
      END IF;

      RETURN NEW;

    END;
  $$;
CREATE OR REPLACE TRIGGER controllo_appelli_per_anno
  BEFORE INSERT OR UPDATE
  ON appelli
  FOR EACH ROW
  EXECUTE PROCEDURE controllo_appelli_per_anno_func();

-- controlla che le propedeuticitià siano rispettate all'iscrizione ad un appello
CREATE OR REPLACE FUNCTION controllo_propedeuticita_iscrizione_func()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
    DECLARE _insegnamento VARCHAR(6);
    DECLARE _cdl VARCHAR(6);
    DECLARE _cdl_studente VARCHAR(6);
    DECLARE _c INTEGER;
    BEGIN

      SET search_path TO unimia;

      SELECT i.codice, i.corso_di_laurea INTO _insegnamento, _cdl
      FROM appelli AS a
      INNER JOIN insegnamenti AS i ON i.codice = a.insegnamento
      WHERE a.codice = NEW.appello;

      SELECT s.corso_di_laurea INTO _cdl_studente
      FROM studenti AS s
      WHERE s.id = NEW.studente;

      -- controllo corso di laurea
      IF _cdl != _cdl_studente THEN
        raise exception E'Il corso di laurea dell\'appello non corrisponde a quello dello studente';
      END IF;

      -- controllo propedeuticità
      WITH RECURSIVE propedeutici AS (
          -- non-recursive term
          SELECT p.insegnamento_propedeutico
          FROM propedeuticita AS p
          WHERE insegnamento = _insegnamento
        UNION
          -- recursive term
          SELECT p2.insegnamento_propedeutico
          FROM propedeutici AS p
          INNER JOIN propedeuticita AS p2 ON p.insegnamento_propedeutico = p2.insegnamento
      )
      SELECT count(*) INTO _c
      FROM propedeutici AS p
      WHERE NOT EXISTS (
        SELECT *
        FROM get_valutazioni_per_studente(NEW.studente) AS val
        WHERE val.__insegnamento = p.insegnamento_propedeutico
        AND val.__valida = true
      );

      IF _c > 0 THEN
        raise exception 'Non sono rispettate tutte le propedeuticità';
      END IF;

      RETURN NEW;

    END;
  $$;
CREATE OR REPLACE TRIGGER controllo_propedeuticita_iscrizione
  BEFORE INSERT
  ON iscrizioni
  FOR EACH ROW
  EXECUTE PROCEDURE controllo_propedeuticita_iscrizione_func();

-- sposta uno studente e le sue iscrizioni nell'archivio alla cancellazione
CREATE OR REPLACE FUNCTION archivia_studente_func()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
    DECLARE _esami_mancanti INTEGER;
    DECLARE _motivazione MOTIVAZIONE_ARCHIVIO;
    BEGIN

      SET search_path TO unimia;

      SELECT count(*) INTO _esami_mancanti
      FROM get_esami_mancanti_per_studente(OLD.id);

      IF _esami_mancanti > 0 THEN
        _motivazione := 'Rinuncia agli studi';
      ELSE
        _motivazione := 'Laurea';
      END IF;

      INSERT INTO archivio_studenti
      VALUES (OLD.id, OLD.matricola, OLD.corso_di_laurea, _motivazione);

      WITH old_iscrizioni AS (
        DELETE FROM iscrizioni AS isc
        WHERE isc.studente = OLD.id
        RETURNING isc.*
      )
      INSERT INTO archivio_iscrizioni SELECT * FROM old_iscrizioni;

      UPDATE utenti SET tipo = 'ex_studente' WHERE id = OLD.id;

      RETURN OLD;

    END;
  $$;
CREATE OR REPLACE TRIGGER archivia_studente
  BEFORE DELETE
  ON studenti
  FOR EACH ROW
  EXECUTE PROCEDURE archivia_studente_func();
