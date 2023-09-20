--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS unimia;
--
-- Name: unimia; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE unimia WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


\connect unimia

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: unimia; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA unimia;


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA unimia;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: anno_insegnamento; Type: TYPE; Schema: unimia; Owner: -
--

CREATE TYPE unimia.anno_insegnamento AS ENUM (
    '1',
    '2',
    '3',
    '4',
    '5'
);


--
-- Name: motivazione_archivio; Type: TYPE; Schema: unimia; Owner: -
--

CREATE TYPE unimia.motivazione_archivio AS ENUM (
    'Rinuncia agli studi',
    'Laurea'
);


--
-- Name: tipo_laurea; Type: TYPE; Schema: unimia; Owner: -
--

CREATE TYPE unimia.tipo_laurea AS ENUM (
    'Triennale',
    'Magistrale',
    'Magistrale a ciclo unico'
);


--
-- Name: tipo_utente; Type: TYPE; Schema: unimia; Owner: -
--

CREATE TYPE unimia.tipo_utente AS ENUM (
    'studente',
    'docente',
    'segretario',
    'ex_studente'
);


--
-- Name: archivia_studente_func(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.archivia_studente_func() RETURNS trigger
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


--
-- Name: controllo_anno_insegnamento_func(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.controllo_anno_insegnamento_func() RETURNS trigger
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


--
-- Name: controllo_appelli_per_anno_func(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.controllo_appelli_per_anno_func() RETURNS trigger
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


--
-- Name: controllo_numero_insegnamenti_per_docente_func(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.controllo_numero_insegnamenti_per_docente_func() RETURNS trigger
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


--
-- Name: controllo_propedeuticita_cicliche_func(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.controllo_propedeuticita_cicliche_func() RETURNS trigger
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


--
-- Name: controllo_propedeuticita_iscrizione_func(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.controllo_propedeuticita_iscrizione_func() RETURNS trigger
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


--
-- Name: delete_appello(uuid); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.delete_appello(IN _codice uuid)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM appelli
      WHERE codice = _codice;

    END;
  $$;


--
-- Name: delete_corso_di_laurea(character varying); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.delete_corso_di_laurea(IN _codice character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM corsi_di_laurea
      WHERE codice = _codice;

    END;
  $$;


--
-- Name: delete_docente(uuid); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.delete_docente(IN _id uuid)
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


--
-- Name: delete_insegnamento(character varying); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.delete_insegnamento(IN _codice character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM insegnamenti
      WHERE codice = _codice;

    END;
  $$;


--
-- Name: delete_segretario(uuid); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.delete_segretario(IN _id uuid)
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


--
-- Name: delete_studente(uuid); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.delete_studente(IN _id uuid)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM studenti
      WHERE id = _id;

    END;
  $$;


--
-- Name: disiscriviti_appello(uuid, uuid); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.disiscriviti_appello(IN _id uuid, IN _codice uuid)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM iscrizioni AS i WHERE i.appello = _codice AND i.studente = _id;

    END;
  $$;


--
-- Name: edit_appello(uuid, date, time without time zone, text); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.edit_appello(IN _codice uuid, IN _data date, IN _ora time without time zone, IN _luogo text)
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
        luogo = COALESCE(NULLIF(_luogo, ''), luogo)
      WHERE codice = _codice;

    END;
  $$;


--
-- Name: edit_corso_di_laurea(character varying, character varying, unimia.tipo_laurea, text, text); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.edit_corso_di_laurea(IN _codice character varying, IN _new_codice character varying, IN _tipo unimia.tipo_laurea, IN _nome text, IN _descrizione text)
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


--
-- Name: edit_docente(uuid, text, text, text); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.edit_docente(IN _id uuid, IN _nome text, IN _cognome text, IN _email text)
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


--
-- Name: edit_insegnamento(character varying, character varying, character varying, text, text, unimia.anno_insegnamento, uuid, character varying[]); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.edit_insegnamento(IN _codice character varying, IN _new_codice character varying, IN _corso_di_laurea character varying, IN _nome text, IN _descrizione text, IN _anno unimia.anno_insegnamento, IN _responsabile uuid, IN _propedeuiticita character varying[])
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

      DELETE FROM propedeuticita AS p
      WHERE p.insegnamento = _new_codice;

      IF _propedeuiticita IS NOT NULL THEN
        FOREACH _propedeutico IN ARRAY _propedeuiticita LOOP
          INSERT INTO propedeuticita VALUES (COALESCE(NULLIF(_new_codice, ''), _codice), _propedeutico);
        END LOOP;
      END IF;

    END;
  $$;


--
-- Name: edit_password(uuid, text, text); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.edit_password(IN _id uuid, IN _old_password text, IN _password text)
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


--
-- Name: edit_segretario(uuid, text, text, text); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.edit_segretario(IN _id uuid, IN _nome text, IN _cognome text, IN _email text)
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


--
-- Name: edit_studente(uuid, text, text, text, character, character varying); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.edit_studente(IN _id uuid, IN _nome text, IN _cognome text, IN _email text, IN _matricola character, IN _corso_di_laurea character varying)
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


--
-- Name: edit_user_password(text, text); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.edit_user_password(IN _email text, IN _password text)
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


--
-- Name: genera_mail_func(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.genera_mail_func() RETURNS trigger
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


--
-- Name: genera_matricola_func(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.genera_matricola_func() RETURNS trigger
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


--
-- Name: get_appelli(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_appelli() RETURNS TABLE(__codice uuid, __corso_di_laurea character varying, __nome_corso_di_laurea text, __insegnamento character varying, __nome_insegnamento text, __data date, __ora time without time zone, __luogo text, __docente uuid, __nome_docente text, __da_valutare integer)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT a.codice, i.corso_di_laurea, cdl.nome, a.insegnamento, i.nome, a.data, a.ora, a.luogo, i.responsabile, CONCAT(u.nome, ' ', u.cognome),
          (
            SELECT count(*)
            FROM iscrizioni AS isc
            WHERE isc.appello = a.codice
            AND isc.voto IS NULL
          )::INTEGER AS da_valutare
        FROM appelli AS a
        INNER JOIN insegnamenti AS i ON i.codice = a.insegnamento
        INNER JOIN utenti AS u ON u.id = i.responsabile
        INNER JOIN corsi_di_laurea AS cdl ON cdl.codice = i.corso_di_laurea
        LEFT JOIN iscrizioni AS isc ON isc.appello = a.codice
        ORDER BY i.corso_di_laurea, a.insegnamento, a.data;

    END;
  $$;


--
-- Name: get_appelli_per_docente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_appelli_per_docente(_id uuid) RETURNS TABLE(__codice uuid, __insegnamento character varying, __nome_insegnamento text, __data date, __ora time without time zone, __luogo text, __da_valutare integer)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT a.codice, a.insegnamento, i.nome, a.data, a.ora, a.luogo,
          (
            SELECT count(*)
            FROM iscrizioni AS isc
            WHERE isc.appello = a.codice
            AND isc.voto IS NULL
          )::INTEGER AS da_valutare
        FROM appelli AS a
        INNER JOIN insegnamenti AS i ON i.codice = a.insegnamento
        LEFT JOIN iscrizioni AS isc ON isc.appello = a.codice
        WHERE i.responsabile = _id
        ORDER BY a.insegnamento, a.data;

    END;
  $$;


--
-- Name: get_appelli_per_studente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_appelli_per_studente(_id uuid) RETURNS TABLE(__codice uuid, __insegnamento character varying, __nome_insegnamento text, __data date, __ora time without time zone, __luogo text, __ultimo_voto integer, __iscritto boolean)
    LANGUAGE plpgsql
    AS $$
    DECLARE _cdl VARCHAR(6);
    BEGIN

      SET search_path TO unimia;

      SELECT s.corso_di_laurea INTO _cdl
      FROM studenti AS s
      WHERE s.id = _id;

      RETURN QUERY
        SELECT a.codice, a.insegnamento, i.nome, a.data, a.ora, a.luogo,
        ( -- ultimo voto (se presente)
          SELECT isc2.voto
          FROM iscrizioni AS isc2
          INNER JOIN appelli AS a2 on a2.codice = isc2.appello
          INNER JOIN insegnamenti AS i2 ON i2.codice = a2.insegnamento
          WHERE isc2.studente = _id
          AND i2.codice = a.insegnamento
          AND isc2.voto IS NOT NULL
          ORDER BY a2.data
          LIMIT 1
        ) AS ultimo_voto,
        ( -- già iscritto (l'appello deve venir visualizzato lo stesso)
          CASE
            WHEN EXISTS (
              SELECT *
              FROM iscrizioni AS isc2
              WHERE isc2.studente = _id
              AND isc2.appello = a.codice
            ) THEN true
            ELSE false
          END
        ) AS iscritto
        FROM appelli AS a
        INNER JOIN insegnamenti AS i ON i.codice = a.insegnamento
        WHERE i.corso_di_laurea = _cdl
        AND a.data > Now()
        ORDER BY i.codice, a.data;

    END;
  $$;


--
-- Name: get_corsi_di_laurea(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_corsi_di_laurea() RETURNS TABLE(__codice character varying, __tipo unimia.tipo_laurea, __nome text, __descrizione text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT c.codice, c.tipo, c.nome, c.descrizione
        FROM corsi_di_laurea AS c
        ORDER BY c.codice;

    END;
  $$;


--
-- Name: get_docente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_docente(_id uuid) RETURNS TABLE(__id uuid, __nome text, __cognome text, __email text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email
        FROM docenti AS d
        INNER JOIN utenti AS u ON u.id = d.id
        WHERE u.id = _id;

    END;
  $$;


--
-- Name: get_docenti(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_docenti() RETURNS TABLE(__id uuid, __nome text, __cognome text, __email text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email
        FROM docenti AS d
        INNER JOIN utenti AS u ON u.id = d.id
        ORDER BY u.cognome, u.nome;

    END;
  $$;


--
-- Name: get_esami_mancanti(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_esami_mancanti() RETURNS TABLE(__studente uuid, __nome_studente text, __matricola character, __corso_di_laurea character varying, __nome_corso_di_laurea text, __codice character varying, __nome text, __descrizione text, __anno unimia.anno_insegnamento, __responsabile uuid, __nome_responsabile text, __email_responsabile text, __propedeuticita text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT stu.id, CONCAT(stu.nome, ' ', stu.cognome), s.matricola,
               s.corso_di_laurea, cdl.nome,
               i.codice, i.nome, i.descrizione, i.anno,
               i.responsabile, CONCAT(doc.nome, ' ', doc.cognome), doc.email,
               string_agg(insegnamento_propedeutico, ', ')
        FROM studenti AS s
        INNER JOIN utenti AS stu ON stu.id = s.id
        INNER JOIN corsi_di_laurea AS cdl ON cdl.codice = s.corso_di_laurea
        INNER JOIN insegnamenti AS i ON i.corso_di_laurea = s.corso_di_laurea
        LEFT JOIN propedeuticita AS p ON p.insegnamento = i.codice
        INNER JOIN utenti AS doc ON doc.id = i.responsabile
        WHERE NOT EXISTS (
          SELECT *
          FROM iscrizioni AS isc
          INNER JOIN appelli AS a ON a.codice = isc.appello
          WHERE a.insegnamento = i.codice
          AND isc.voto IS NOT NULL
          AND isc.voto >= 18
          AND NOT EXISTS (
            SELECT *
            FROM iscrizioni AS isc2
            INNER JOIN appelli AS a2 ON a2.codice = isc2.appello
            WHERE a2.insegnamento = a.insegnamento
            AND a2.data > a.data
            AND Now() > a2.data
          )

        )
        GROUP BY stu.id, CONCAT(stu.nome, ' ', stu.cognome), s.matricola,
               s.corso_di_laurea, cdl.nome,
               i.codice, i.nome, i.descrizione, i.anno,
               i.responsabile, CONCAT(doc.nome, ' ', doc.cognome), doc.email
        ORDER BY stu.cognome, stu.nome, s.matricola,
               i.anno, i.codice;

    END;
  $$;


--
-- Name: get_esami_mancanti_per_studente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_esami_mancanti_per_studente(_id uuid) RETURNS TABLE(__codice character varying, __nome text, __descrizione text, __anno unimia.anno_insegnamento, __responsabile uuid, __nome_responsabile text, __email_responsabile text, __propedeuticita text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT i.codice,i.nome,i.descrizione,i.anno,i.responsabile,CONCAT(doc.nome, ' ', doc.cognome),doc.email,string_agg(insegnamento_propedeutico, ', ')
        FROM studenti AS s
        INNER JOIN insegnamenti AS i ON i.corso_di_laurea = s.corso_di_laurea
        LEFT JOIN propedeuticita AS p ON p.insegnamento = i.codice
        INNER JOIN utenti AS doc ON doc.id = i.responsabile
        WHERE s.id = _id
        AND NOT EXISTS (
          SELECT *
          FROM iscrizioni AS isc
          INNER JOIN appelli AS a ON a.codice = isc.appello
          WHERE isc.studente = _id
          AND a.insegnamento = i.codice
          AND isc.voto IS NOT NULL
          AND isc.voto >= 18
          AND NOT EXISTS (
            SELECT *
            FROM iscrizioni AS isc2
            INNER JOIN appelli AS a2 ON a2.codice = isc2.appello
            WHERE isc2.studente = _id
            AND a2.insegnamento = a.insegnamento
            AND a2.data > a.data
            AND Now() > a2.data
          )
        )
        GROUP BY i.codice, i.nome, i.descrizione, i.anno, i.responsabile, CONCAT(doc.nome, ' ', doc.cognome), doc.email
        ORDER BY i.corso_di_laurea, i.anno, i.codice;

    END;
  $$;


--
-- Name: get_ex_studente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_ex_studente(_id uuid) RETURNS TABLE(__id uuid, __nome text, __cognome text, __email text, __matricola character, __corso_di_laurea character varying, __nome_corso_di_laurea text, __motivazione unimia.motivazione_archivio)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email, s.matricola, s.corso_di_laurea, cdl.nome, s.motivazione
        FROM archivio_studenti AS s
        INNER JOIN utenti AS u ON u.id = s.id
        INNER JOIN corsi_di_laurea AS cdl ON cdl.codice = s.corso_di_laurea
        WHERE u.id = _id;

    END;
  $$;


--
-- Name: get_ex_studenti(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_ex_studenti() RETURNS TABLE(__id uuid, __nome text, __cognome text, __email text, __matricola character, __corso_di_laurea character varying, __nome_corso_di_laurea text, __motivazione unimia.motivazione_archivio)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email, s.matricola, s.corso_di_laurea, cdl.nome, s.motivazione
        FROM archivio_studenti AS s
        INNER JOIN utenti AS u ON u.id = s.id
        INNER JOIN corsi_di_laurea AS cdl ON cdl.codice = s.corso_di_laurea
        ORDER BY s.corso_di_laurea, u.cognome, u.nome;

    END;
  $$;


--
-- Name: get_ex_valutazioni(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_ex_valutazioni() RETURNS TABLE(__appello uuid, __insegnamento character varying, __nome_insegnamento text, __data date, __docente uuid, __nome_docente text, __studente uuid, __nome_studente text, __matricola_studente character, __voto integer, __valida boolean, __media numeric)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT isc.appello, a.insegnamento, i.nome, a.data,
          i.responsabile, CONCAT(udoc.nome, ' ', udoc.cognome),
          isc.studente, CONCAT(ustu.nome, ' ', ustu.cognome), s.matricola,
          isc.voto,
          (
            CASE
              -- voto in attesa o insufficiente
              WHEN (isc.voto IS NULL) OR (isc.voto < 18) THEN false
              -- voto sovrascritto da appello più recente
              WHEN EXISTS (
                SELECT *
                FROM archivio_iscrizioni AS isc2
                INNER JOIN appelli a2 on isc2.appello = a2.codice
                WHERE isc2.studente = isc.studente
                AND a2.insegnamento = a.insegnamento
                AND a2.data > a.data
                AND Now() > a2.data
              ) THEN false
              ELSE true
            END
          ) as valida,
          (
            SELECT gmps.__media FROM get_media_per_ex_studente(isc.studente) AS gmps
          ) AS media
        FROM archivio_iscrizioni AS isc
        INNER JOIN appelli AS a ON a.codice = isc.appello
        INNER JOIN insegnamenti i ON a.insegnamento = i.codice
        INNER JOIN utenti AS udoc ON udoc.id = i.responsabile
        INNER JOIN utenti AS ustu ON ustu.id = isc.studente
        INNER JOIN archivio_studenti AS s ON s.id = isc.studente
        WHERE Now() > a.data
        ORDER BY isc.studente, i.codice, a.data;

    END;
  $$;


--
-- Name: get_insegnamenti(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_insegnamenti() RETURNS TABLE(__codice character varying, __corso_di_laurea character varying, __nome_corso_di_laurea text, __nome text, __descrizione text, __anno unimia.anno_insegnamento, __responsabile uuid, __nome_responsabile text, __email_responsabile text, __propedeuticita text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT i.codice, i.corso_di_laurea, cdl.nome, i.nome, i.descrizione, i.anno, i.responsabile, CONCAT(u.nome, ' ', u.cognome), u.email, string_agg(insegnamento_propedeutico, ', ')
        FROM insegnamenti AS i
        INNER JOIN corsi_di_laurea AS cdl ON cdl.codice = i.corso_di_laurea
        INNER JOIN docenti AS d ON d.id = i.responsabile
        INNER JOIN utenti AS u ON d.id = u.id
        LEFT JOIN propedeuticita AS p ON p.insegnamento = i.codice
        GROUP BY i.codice, i.corso_di_laurea, cdl.nome, i.nome, i.descrizione, i.anno, i.responsabile, CONCAT(u.nome, ' ', u.cognome), u.email
        ORDER BY i.corso_di_laurea, i.anno, i.codice;

    END;
  $$;


--
-- Name: get_insegnamenti_per_corso_di_laurea(character varying); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_insegnamenti_per_corso_di_laurea(_corso_di_laurea character varying) RETURNS TABLE(__codice character varying, __nome text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT i.codice, i.nome
        FROM insegnamenti AS i
        WHERE i.corso_di_laurea = _corso_di_laurea
        ORDER BY i.corso_di_laurea, i.anno, i.codice;

    END;
  $$;


--
-- Name: get_insegnamenti_per_docente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_insegnamenti_per_docente(_id uuid) RETURNS TABLE(__codice character varying, __corso_di_laurea character varying, __nome_corso_di_laurea text, __nome text, __descrizione text, __anno unimia.anno_insegnamento, __propedeuticita text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT i.codice, i.corso_di_laurea, cdl.nome, i.nome, i.descrizione, i.anno, string_agg(insegnamento_propedeutico, ', ')
        FROM insegnamenti AS i
        INNER JOIN corsi_di_laurea AS cdl ON cdl.codice = i.corso_di_laurea
        LEFT JOIN propedeuticita AS p ON p.insegnamento = i.codice
        WHERE i.responsabile = _id
        GROUP BY i.codice, i.corso_di_laurea, cdl.nome, i.nome, i.descrizione, i.anno
        ORDER BY i.corso_di_laurea, i.anno, i.codice;

    END;
  $$;


--
-- Name: get_iscrizioni(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_iscrizioni() RETURNS TABLE(__appello uuid, __corso_di_laurea character varying, __nome_corso_di_laurea text, __insegnamento character varying, __nome_insegnamento text, __data date, __docente uuid, __nome_docente text, __studente uuid, __nome_studente text, __matricola character)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT isc.appello, i.corso_di_laurea, cdl.nome, a.insegnamento, i.nome, a.data,
          i.responsabile, CONCAT(udoc.nome, ' ', udoc.cognome),
          isc.studente, CONCAT(ustu.nome, ' ', ustu.cognome), s.matricola
        FROM iscrizioni AS isc
        INNER JOIN appelli AS a ON a.codice = isc.appello
        INNER JOIN insegnamenti AS i ON a.insegnamento = i.codice
        INNER JOIN corsi_di_laurea AS cdl ON cdl.codice = i.corso_di_laurea
        INNER JOIN studenti AS s ON s.id = isc.studente
        INNER JOIN utenti AS ustu ON ustu.id = isc.studente
        INNER JOIN utenti AS udoc ON udoc.id = i.responsabile
        AND isc.voto IS NULL
        ORDER BY i.codice, a.data, ustu.cognome, ustu.nome;

    END;
  $$;


--
-- Name: get_iscrizioni_per_docente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_iscrizioni_per_docente(_id uuid) RETURNS TABLE(__appello uuid, __insegnamento character varying, __nome_insegnamento text, __data date, __studente uuid, __matricola character, __nome text, __email text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT isc.appello, a.insegnamento, i.nome, a.data, isc.studente, s.matricola, CONCAT(u.nome, ' ', u.cognome), u.email
        FROM iscrizioni AS isc
        INNER JOIN appelli AS a ON a.codice = isc.appello
        INNER JOIN insegnamenti i ON a.insegnamento = i.codice
        INNER JOIN studenti AS s ON s.id = isc.studente
        INNER JOIN utenti AS u ON u.id = isc.studente
        WHERE i.responsabile = _id
        AND isc.voto IS NULL
        ORDER BY i.codice, a.data, u.cognome, u.nome;

    END;
  $$;


--
-- Name: get_media_per_ex_studente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_media_per_ex_studente(_id uuid) RETURNS TABLE(__media numeric)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT avg(voto)
        FROM archivio_iscrizioni AS isc
        INNER JOIN appelli AS a ON a.codice = isc.appello
        WHERE studente = _id
        AND voto IS NOT NULL
        AND voto >= 18
        AND NOT EXISTS (
          SELECT *
          FROM archivio_iscrizioni AS isc2
          INNER JOIN appelli AS a2 ON a2.codice = isc2.appello
          WHERE isc2.studente = _id
          AND a2.insegnamento = a.insegnamento
          AND a2.data > a.data
          AND Now() > a2.data
        );

    END;
  $$;


--
-- Name: get_media_per_studente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_media_per_studente(_id uuid) RETURNS TABLE(__media numeric)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT avg(voto)
        FROM iscrizioni AS isc
        INNER JOIN appelli AS a ON a.codice = isc.appello
        WHERE studente = _id
        AND voto IS NOT NULL
        AND voto >= 18
        AND NOT EXISTS (
          SELECT *
          FROM iscrizioni AS isc2
          INNER JOIN appelli AS a2 ON a2.codice = isc2.appello
          WHERE isc2.studente = _id
          AND a2.insegnamento = a.insegnamento
          AND a2.data > a.data
          AND Now() > a2.data
        );

    END;
  $$;


--
-- Name: get_segretari(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_segretari() RETURNS TABLE(__id uuid, __nome text, __cognome text, __email text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email
        FROM segretari AS s
        INNER JOIN utenti AS u ON u.id = s.id
        ORDER BY u.cognome, u.nome;

    END;
  $$;


--
-- Name: get_segretario(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_segretario(_id uuid) RETURNS TABLE(__id uuid, __nome text, __cognome text, __email text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email
        FROM segretari AS s
        INNER JOIN utenti AS u ON u.id = s.id
        WHERE u.id = _id;

    END;
  $$;


--
-- Name: get_studente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_studente(_id uuid) RETURNS TABLE(__id uuid, __nome text, __cognome text, __email text, __matricola character, __corso_di_laurea character varying, __nome_corso_di_laurea text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email, s.matricola, s.corso_di_laurea, cdl.nome
        FROM studenti AS s
        INNER JOIN utenti AS u ON u.id = s.id
        INNER JOIN corsi_di_laurea AS cdl ON cdl.codice = s.corso_di_laurea
        WHERE u.id = _id;

    END;
  $$;


--
-- Name: get_studenti(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_studenti() RETURNS TABLE(__id uuid, __nome text, __cognome text, __email text, __matricola character, __corso_di_laurea character varying, __nome_corso_di_laurea text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT u.id, u.nome, u.cognome, u.email, s.matricola, s.corso_di_laurea, cdl.nome
        FROM studenti AS s
        INNER JOIN utenti AS u ON u.id = s.id
        INNER JOIN corsi_di_laurea AS cdl ON cdl.codice = s.corso_di_laurea
        ORDER BY s.corso_di_laurea, u.cognome, u.nome;

    END;
  $$;


--
-- Name: get_valutazioni(); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_valutazioni() RETURNS TABLE(__appello uuid, __insegnamento character varying, __nome_insegnamento text, __data date, __docente uuid, __nome_docente text, __studente uuid, __nome_studente text, __matricola_studente character, __voto integer, __valida boolean, __media numeric)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT isc.appello, a.insegnamento, i.nome, a.data,
          i.responsabile, CONCAT(udoc.nome, ' ', udoc.cognome),
          isc.studente, CONCAT(ustu.nome, ' ', ustu.cognome), s.matricola,
          isc.voto,
          (
            CASE
              -- voto in attesa o insufficiente
              WHEN (isc.voto IS NULL) OR (isc.voto < 18) THEN false
              -- voto sovrascritto da appello più recente
              WHEN EXISTS (
                SELECT *
                FROM iscrizioni AS isc2
                INNER JOIN appelli a2 on isc2.appello = a2.codice
                WHERE isc2.studente = isc.studente
                AND a2.insegnamento = a.insegnamento
                AND a2.data > a.data
                AND Now() > a2.data
              ) THEN false
              ELSE true
            END
          ) as valida,
          (
            SELECT gmps.__media FROM get_media_per_studente(isc.studente) AS gmps
          ) AS media
        FROM iscrizioni AS isc
        INNER JOIN appelli AS a ON a.codice = isc.appello
        INNER JOIN insegnamenti i ON a.insegnamento = i.codice
        INNER JOIN utenti AS udoc ON udoc.id = i.responsabile
        INNER JOIN utenti AS ustu ON ustu.id = isc.studente
        INNER JOIN studenti AS s ON s.id = isc.studente
        WHERE Now() > a.data
        ORDER BY isc.studente, i.codice, a.data;

    END;
  $$;


--
-- Name: get_valutazioni_per_docente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_valutazioni_per_docente(_id uuid) RETURNS TABLE(__appello uuid, __insegnamento character varying, __nome_insegnamento text, __data date, __studente uuid, __matricola character, __nome text, __email text, __voto integer)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT isc.appello, a.insegnamento, i.nome, a.data, isc.studente, s.matricola, CONCAT(u.nome, ' ', u.cognome), u.email, isc.voto
        FROM iscrizioni AS isc
        INNER JOIN appelli AS a ON a.codice = isc.appello
        INNER JOIN insegnamenti i ON a.insegnamento = i.codice
        INNER JOIN studenti AS s ON s.id = isc.studente
        INNER JOIN utenti AS u ON u.id = isc.studente
        WHERE i.responsabile = _id
        AND isc.voto IS NOT NULL
        ORDER BY i.codice, a.data, u.cognome, u.nome;

    END;
  $$;


--
-- Name: get_valutazioni_per_ex_studente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_valutazioni_per_ex_studente(_id uuid) RETURNS TABLE(__studente uuid, __appello uuid, __insegnamento character varying, __nome_insegnamento text, __data date, __docente uuid, __nome_docente text, __voto integer, __valida boolean, __media numeric)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT _id, isc.appello, a.insegnamento, i.nome, a.data, i.responsabile, CONCAT(u.nome, ' ', u.cognome), isc.voto,
          (
            CASE
              -- voto in attesa o insufficiente
              WHEN (isc.voto IS NULL) OR (isc.voto < 18) THEN false
              -- voto sovrascritto da appello più recente
              WHEN EXISTS (
                SELECT *
                FROM archivio_iscrizioni AS isc2
                INNER JOIN appelli AS a2 on isc2.appello = a2.codice
                WHERE isc2.studente = _id
                AND a2.insegnamento = a.insegnamento
                AND a2.data > a.data
                AND Now() > a2.data
              ) THEN false
              ELSE true
            END
          ) as valida,
          (
            SELECT gmps.__media FROM get_media_per_ex_studente(_id) AS gmps
          ) AS media
        FROM archivio_iscrizioni AS isc
        INNER JOIN appelli AS a ON a.codice = isc.appello
        INNER JOIN insegnamenti i ON a.insegnamento = i.codice
        INNER JOIN utenti AS u ON u.id = i.responsabile
        WHERE isc.studente = _id
        AND Now() > a.data
        ORDER BY i.codice, a.data;

    END;
  $$;


--
-- Name: get_valutazioni_per_studente(uuid); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.get_valutazioni_per_studente(_id uuid) RETURNS TABLE(__studente uuid, __appello uuid, __insegnamento character varying, __nome_insegnamento text, __data date, __docente uuid, __nome_docente text, __voto integer, __valida boolean, __media numeric)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      RETURN QUERY
        SELECT _id, isc.appello, a.insegnamento, i.nome, a.data, i.responsabile, CONCAT(u.nome, ' ', u.cognome), isc.voto,
          (
            CASE
              -- voto in attesa o insufficiente
              WHEN (isc.voto IS NULL) OR (isc.voto < 18) THEN false
              -- voto sovrascritto da appello più recente
              WHEN EXISTS (
                SELECT *
                FROM iscrizioni AS isc2
                INNER JOIN appelli AS a2 on isc2.appello = a2.codice
                WHERE isc2.studente = _id
                AND a2.insegnamento = a.insegnamento
                AND a2.data > a.data
                AND Now() > a2.data
              ) THEN false
              ELSE true
            END
          ) as valida,
          (
            SELECT gmps.__media FROM get_media_per_studente(_id) AS gmps
          ) AS media
        FROM iscrizioni AS isc
        INNER JOIN appelli AS a ON a.codice = isc.appello
        INNER JOIN insegnamenti i ON a.insegnamento = i.codice
        INNER JOIN utenti AS u ON u.id = i.responsabile
        WHERE isc.studente = _id
        AND Now() > a.data
        ORDER BY i.codice, a.data;

    END;
  $$;


--
-- Name: iscriviti_appello(uuid, uuid); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.iscriviti_appello(IN _id uuid, IN _codice uuid)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      INSERT INTO iscrizioni VALUES(_codice, _id, NULL);

    END;
  $$;


--
-- Name: login(text, text); Type: FUNCTION; Schema: unimia; Owner: -
--

CREATE FUNCTION unimia.login(_email text, _password text) RETURNS TABLE(__id uuid, __type unimia.tipo_utente)
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


--
-- Name: new_appello(character varying, date, time without time zone, text); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.new_appello(IN _insegnamento character varying, IN _data date, IN _ora time without time zone, IN _luogo text)
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


--
-- Name: new_corso_di_laurea(character varying, unimia.tipo_laurea, text, text); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.new_corso_di_laurea(IN _codice character varying, IN _tipo unimia.tipo_laurea, IN _nome text, IN _descrizione text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      INSERT INTO corsi_di_laurea(codice, tipo, nome, descrizione)
      VALUES (_codice, _tipo, _nome, _descrizione);

    END;
  $$;


--
-- Name: new_docente(text, text, text); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.new_docente(IN _nome text, IN _cognome text, IN _password text)
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


--
-- Name: new_insegnamento(character varying, character varying, text, text, unimia.anno_insegnamento, uuid, character varying[]); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.new_insegnamento(IN _codice character varying, IN _corso_di_laurea character varying, IN _nome text, IN _descrizione text, IN _anno unimia.anno_insegnamento, IN _responsabile uuid, IN _propedeuiticita character varying[])
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


--
-- Name: new_segretario(text, text, text); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.new_segretario(IN _nome text, IN _cognome text, IN _password text)
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


--
-- Name: new_studente(text, text, text, character varying); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.new_studente(IN _nome text, IN _cognome text, IN _password text, IN _corso_di_laurea character varying)
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


--
-- Name: valuta_iscrizione(uuid, uuid, integer); Type: PROCEDURE; Schema: unimia; Owner: -
--

CREATE PROCEDURE unimia.valuta_iscrizione(IN _id uuid, IN _codice uuid, IN _voto integer)
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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appelli; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.appelli (
    codice uuid DEFAULT gen_random_uuid() NOT NULL,
    insegnamento character varying(6) NOT NULL,
    data date NOT NULL,
    ora time without time zone NOT NULL,
    luogo text NOT NULL
);


--
-- Name: archivio_iscrizioni; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.archivio_iscrizioni (
    appello uuid NOT NULL,
    studente uuid NOT NULL,
    voto integer,
    CONSTRAINT archivio_iscrizioni_voto_check CHECK (((voto >= 0) AND (voto <= 31)))
);


--
-- Name: archivio_studenti; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.archivio_studenti (
    id uuid NOT NULL,
    matricola character(6) NOT NULL,
    corso_di_laurea character varying(6) NOT NULL,
    motivazione unimia.motivazione_archivio NOT NULL,
    CONSTRAINT archivio_studenti_matricola_check CHECK ((matricola ~* '^\d{6}$'::text))
);


--
-- Name: corsi_di_laurea; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.corsi_di_laurea (
    codice character varying(6) NOT NULL,
    tipo unimia.tipo_laurea NOT NULL,
    nome text NOT NULL,
    descrizione text NOT NULL
);


--
-- Name: docenti; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.docenti (
    id uuid NOT NULL
);


--
-- Name: insegnamenti; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.insegnamenti (
    codice character varying(6) NOT NULL,
    corso_di_laurea character varying(6) NOT NULL,
    nome text NOT NULL,
    descrizione text NOT NULL,
    anno unimia.anno_insegnamento NOT NULL,
    responsabile uuid NOT NULL
);


--
-- Name: iscrizioni; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.iscrizioni (
    appello uuid NOT NULL,
    studente uuid NOT NULL,
    voto integer,
    CONSTRAINT iscrizioni_voto_check CHECK (((voto >= 0) AND (voto <= 31)))
);


--
-- Name: propedeuticita; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.propedeuticita (
    insegnamento character varying(6) NOT NULL,
    insegnamento_propedeutico character varying(6) NOT NULL
);


--
-- Name: segretari; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.segretari (
    id uuid NOT NULL
);


--
-- Name: studenti; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.studenti (
    id uuid NOT NULL,
    matricola character(6) NOT NULL,
    corso_di_laurea character varying(6) NOT NULL,
    CONSTRAINT studenti_matricola_check CHECK ((matricola ~* '^\d{6}$'::text))
);


--
-- Name: utenti; Type: TABLE; Schema: unimia; Owner: -
--

CREATE TABLE unimia.utenti (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    password text NOT NULL,
    nome text NOT NULL,
    cognome text NOT NULL,
    tipo unimia.tipo_utente NOT NULL,
    email text NOT NULL,
    CONSTRAINT utenti_cognome_check CHECK ((cognome ~* '^.+$'::text)),
    CONSTRAINT utenti_email_check CHECK ((email ~* '^[A-Za-z0-9._%-]+@(studente|docente|segretario).superuni.it$'::text)),
    CONSTRAINT utenti_nome_check CHECK ((nome ~* '^.+$'::text)),
    CONSTRAINT utenti_password_check CHECK ((password ~ '^.{8,}$'::text))
);


--
-- Name: appelli appelli_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.appelli
    ADD CONSTRAINT appelli_pkey PRIMARY KEY (codice);


--
-- Name: archivio_iscrizioni archivio_iscrizioni_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.archivio_iscrizioni
    ADD CONSTRAINT archivio_iscrizioni_pkey PRIMARY KEY (appello, studente);


--
-- Name: archivio_studenti archivio_studenti_matricola_key; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.archivio_studenti
    ADD CONSTRAINT archivio_studenti_matricola_key UNIQUE (matricola);


--
-- Name: archivio_studenti archivio_studenti_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.archivio_studenti
    ADD CONSTRAINT archivio_studenti_pkey PRIMARY KEY (id);


--
-- Name: corsi_di_laurea corsi_di_laurea_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.corsi_di_laurea
    ADD CONSTRAINT corsi_di_laurea_pkey PRIMARY KEY (codice);


--
-- Name: docenti docenti_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.docenti
    ADD CONSTRAINT docenti_pkey PRIMARY KEY (id);


--
-- Name: insegnamenti insegnamenti_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.insegnamenti
    ADD CONSTRAINT insegnamenti_pkey PRIMARY KEY (codice);


--
-- Name: iscrizioni iscrizioni_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.iscrizioni
    ADD CONSTRAINT iscrizioni_pkey PRIMARY KEY (appello, studente);


--
-- Name: propedeuticita propedeuticita_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.propedeuticita
    ADD CONSTRAINT propedeuticita_pkey PRIMARY KEY (insegnamento, insegnamento_propedeutico);


--
-- Name: segretari segretari_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.segretari
    ADD CONSTRAINT segretari_pkey PRIMARY KEY (id);


--
-- Name: studenti studenti_matricola_key; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.studenti
    ADD CONSTRAINT studenti_matricola_key UNIQUE (matricola);


--
-- Name: studenti studenti_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.studenti
    ADD CONSTRAINT studenti_pkey PRIMARY KEY (id);


--
-- Name: utenti utenti_email_key; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.utenti
    ADD CONSTRAINT utenti_email_key UNIQUE (email);


--
-- Name: utenti utenti_pkey; Type: CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.utenti
    ADD CONSTRAINT utenti_pkey PRIMARY KEY (id);


--
-- Name: studenti archivia_studente; Type: TRIGGER; Schema: unimia; Owner: -
--

CREATE TRIGGER archivia_studente BEFORE DELETE ON unimia.studenti FOR EACH ROW EXECUTE FUNCTION unimia.archivia_studente_func();


--
-- Name: insegnamenti controllo_anno_insegnamento; Type: TRIGGER; Schema: unimia; Owner: -
--

CREATE TRIGGER controllo_anno_insegnamento BEFORE INSERT OR UPDATE ON unimia.insegnamenti FOR EACH ROW EXECUTE FUNCTION unimia.controllo_anno_insegnamento_func();


--
-- Name: appelli controllo_appelli_per_anno; Type: TRIGGER; Schema: unimia; Owner: -
--

CREATE TRIGGER controllo_appelli_per_anno BEFORE INSERT OR UPDATE ON unimia.appelli FOR EACH ROW EXECUTE FUNCTION unimia.controllo_appelli_per_anno_func();


--
-- Name: insegnamenti controllo_numero_insegnamenti_per_docente; Type: TRIGGER; Schema: unimia; Owner: -
--

CREATE TRIGGER controllo_numero_insegnamenti_per_docente BEFORE INSERT OR UPDATE ON unimia.insegnamenti FOR EACH ROW EXECUTE FUNCTION unimia.controllo_numero_insegnamenti_per_docente_func();


--
-- Name: propedeuticita controllo_propedeuticita_cicliche; Type: TRIGGER; Schema: unimia; Owner: -
--

CREATE TRIGGER controllo_propedeuticita_cicliche BEFORE INSERT OR UPDATE ON unimia.propedeuticita FOR EACH ROW EXECUTE FUNCTION unimia.controllo_propedeuticita_cicliche_func();


--
-- Name: iscrizioni controllo_propedeuticita_iscrizione; Type: TRIGGER; Schema: unimia; Owner: -
--

CREATE TRIGGER controllo_propedeuticita_iscrizione BEFORE INSERT ON unimia.iscrizioni FOR EACH ROW EXECUTE FUNCTION unimia.controllo_propedeuticita_iscrizione_func();


--
-- Name: utenti genera_mail; Type: TRIGGER; Schema: unimia; Owner: -
--

CREATE TRIGGER genera_mail BEFORE INSERT ON unimia.utenti FOR EACH ROW EXECUTE FUNCTION unimia.genera_mail_func();


--
-- Name: studenti genera_matricola; Type: TRIGGER; Schema: unimia; Owner: -
--

CREATE TRIGGER genera_matricola BEFORE INSERT ON unimia.studenti FOR EACH ROW EXECUTE FUNCTION unimia.genera_matricola_func();


--
-- Name: appelli appelli_insegnamento_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.appelli
    ADD CONSTRAINT appelli_insegnamento_fkey FOREIGN KEY (insegnamento) REFERENCES unimia.insegnamenti(codice) ON UPDATE CASCADE;


--
-- Name: archivio_iscrizioni archivio_iscrizioni_appello_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.archivio_iscrizioni
    ADD CONSTRAINT archivio_iscrizioni_appello_fkey FOREIGN KEY (appello) REFERENCES unimia.appelli(codice);


--
-- Name: archivio_iscrizioni archivio_iscrizioni_studente_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.archivio_iscrizioni
    ADD CONSTRAINT archivio_iscrizioni_studente_fkey FOREIGN KEY (studente) REFERENCES unimia.archivio_studenti(id);


--
-- Name: archivio_studenti archivio_studenti_corso_di_laurea_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.archivio_studenti
    ADD CONSTRAINT archivio_studenti_corso_di_laurea_fkey FOREIGN KEY (corso_di_laurea) REFERENCES unimia.corsi_di_laurea(codice) ON UPDATE CASCADE;


--
-- Name: archivio_studenti archivio_studenti_id_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.archivio_studenti
    ADD CONSTRAINT archivio_studenti_id_fkey FOREIGN KEY (id) REFERENCES unimia.utenti(id);


--
-- Name: docenti docenti_id_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.docenti
    ADD CONSTRAINT docenti_id_fkey FOREIGN KEY (id) REFERENCES unimia.utenti(id);


--
-- Name: insegnamenti insegnamenti_corso_di_laurea_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.insegnamenti
    ADD CONSTRAINT insegnamenti_corso_di_laurea_fkey FOREIGN KEY (corso_di_laurea) REFERENCES unimia.corsi_di_laurea(codice) ON UPDATE CASCADE;


--
-- Name: insegnamenti insegnamenti_responsabile_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.insegnamenti
    ADD CONSTRAINT insegnamenti_responsabile_fkey FOREIGN KEY (responsabile) REFERENCES unimia.docenti(id);


--
-- Name: iscrizioni iscrizioni_appello_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.iscrizioni
    ADD CONSTRAINT iscrizioni_appello_fkey FOREIGN KEY (appello) REFERENCES unimia.appelli(codice);


--
-- Name: iscrizioni iscrizioni_studente_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.iscrizioni
    ADD CONSTRAINT iscrizioni_studente_fkey FOREIGN KEY (studente) REFERENCES unimia.studenti(id);


--
-- Name: propedeuticita propedeuticita_insegnamento_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.propedeuticita
    ADD CONSTRAINT propedeuticita_insegnamento_fkey FOREIGN KEY (insegnamento) REFERENCES unimia.insegnamenti(codice) ON UPDATE CASCADE;


--
-- Name: propedeuticita propedeuticita_insegnamento_propedeutico_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.propedeuticita
    ADD CONSTRAINT propedeuticita_insegnamento_propedeutico_fkey FOREIGN KEY (insegnamento_propedeutico) REFERENCES unimia.insegnamenti(codice) ON UPDATE CASCADE;


--
-- Name: segretari segretari_id_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.segretari
    ADD CONSTRAINT segretari_id_fkey FOREIGN KEY (id) REFERENCES unimia.utenti(id);


--
-- Name: studenti studenti_corso_di_laurea_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.studenti
    ADD CONSTRAINT studenti_corso_di_laurea_fkey FOREIGN KEY (corso_di_laurea) REFERENCES unimia.corsi_di_laurea(codice) ON UPDATE CASCADE;


--
-- Name: studenti studenti_id_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: -
--

ALTER TABLE ONLY unimia.studenti
    ADD CONSTRAINT studenti_id_fkey FOREIGN KEY (id) REFERENCES unimia.utenti(id);


--
-- PostgreSQL database dump complete
--

