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
      WHERE u.email LIKE CONCAT(NEW.nome, '.', NEW.cognome, '%');

      IF _num = 0 THEN
        NEW.email := CONCAT(NEW.nome, '.', NEW.cognome, '@', NEW.tipo, '.superuni.it');
      ELSE
        NEW.email := CONCAT(NEW.nome, '.', NEW.cognome, _num, '@', NEW.tipo, '.superuni.it');
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
