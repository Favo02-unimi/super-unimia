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

-- controlla che non esistano più appelli dello corso di laurea dello stesso corso alla creazione di un appello
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
      AND a.data = NEW.data;

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
