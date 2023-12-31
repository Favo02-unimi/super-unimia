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
    __matricola CHAR(6),
    __corso_di_laurea VARCHAR(6),
    __nome_corso_di_laurea TEXT
  )
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

-- restituisce tutti gli ex studenti disponibili
CREATE OR REPLACE FUNCTION get_ex_studenti ()
  RETURNS TABLE (
    __id uuid,
    __nome TEXT,
    __cognome TEXT,
    __email TEXT,
    __matricola CHAR(6),
    __corso_di_laurea VARCHAR(6),
    __nome_corso_di_laurea TEXT,
    __motivazione MOTIVAZIONE_ARCHIVIO
  )
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

-- restituisce uno studente dato il suo id
CREATE OR REPLACE FUNCTION get_studente (
  _id uuid
)
  RETURNS TABLE (
    __id uuid,
    __nome TEXT,
    __cognome TEXT,
    __email TEXT,
    __matricola CHAR(6),
    __corso_di_laurea VARCHAR(6),
    __nome_corso_di_laurea TEXT
  )
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

-- restituisce un ex studente dato il suo id
CREATE OR REPLACE FUNCTION get_ex_studente (
  _id uuid
)
  RETURNS TABLE (
    __id uuid,
    __nome TEXT,
    __cognome TEXT,
    __email TEXT,
    __matricola CHAR(6),
    __corso_di_laurea VARCHAR(6),
    __nome_corso_di_laurea TEXT,
    __motivazione MOTIVAZIONE_ARCHIVIO
  )
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
        INNER JOIN utenti AS u ON u.id = d.id
        ORDER BY u.cognome, u.nome;

    END;
  $$;

-- restituisce un docente dato il suo id
CREATE OR REPLACE FUNCTION get_docente (
  _id uuid
)
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
        INNER JOIN utenti AS u ON u.id = d.id
        WHERE u.id = _id;

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
        INNER JOIN utenti AS u ON u.id = s.id
        ORDER BY u.cognome, u.nome;

    END;
  $$;

-- restituisce un segretario dato il suo id
CREATE OR REPLACE FUNCTION get_segretario (
  _id uuid
)
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
        INNER JOIN utenti AS u ON u.id = s.id
        WHERE u.id = _id;

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
        FROM corsi_di_laurea AS c
        ORDER BY c.codice;

    END;
  $$;

-- restituisce tutti gli insegnamenti
CREATE OR REPLACE FUNCTION get_insegnamenti ()
  RETURNS TABLE (
    __codice VARCHAR(6),
    __corso_di_laurea VARCHAR(6),
    __nome_corso_di_laurea TEXT,
    __nome TEXT,
    __descrizione TEXT,
    __anno ANNO_INSEGNAMENTO,
    __responsabile uuid,
    __nome_responsabile TEXT,
    __email_responsabile TEXT,
    __propedeuticita TEXT
  )
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

-- restituisce tutti gli insegnamenti per corso di laurea
CREATE OR REPLACE FUNCTION get_insegnamenti_per_corso_di_laurea (
  _corso_di_laurea VARCHAR(6)
)
  RETURNS TABLE (
    __codice VARCHAR(6),
    __nome TEXT
  )
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

-- restituisce tutti gli appelli
CREATE OR REPLACE FUNCTION get_appelli ()
  RETURNS TABLE (
    __codice uuid,
    __corso_di_laurea VARCHAR(6),
    __nome_corso_di_laurea TEXT,
    __insegnamento VARCHAR(6),
    __nome_insegnamento TEXT,
    __data DATE,
    __ora TIME,
    __luogo TEXT,
    __docente uuid,
    __nome_docente TEXT,
    __da_valutare INTEGER
  )
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

-- restituisce tutte le iscrizioni
CREATE OR REPLACE FUNCTION get_iscrizioni ()
  RETURNS TABLE (
    __appello uuid,
    __corso_di_laurea VARCHAR(6),
    __nome_corso_di_laurea TEXT,
    __insegnamento VARCHAR(6),
    __nome_insegnamento TEXT,
    __data DATE,
    __docente uuid,
    __nome_docente TEXT,
    __studente uuid,
    __nome_studente TEXT,
    __matricola CHAR(6)
  )
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

-- restituisce tutte le valutazioni e le carriere
CREATE OR REPLACE FUNCTION get_valutazioni ()
  RETURNS TABLE (
    __appello uuid,
    __insegnamento VARCHAR(6),
    __nome_insegnamento TEXT,
    __data DATE,
    __docente uuid,
    __nome_docente TEXT,
    __studente uuid,
    __nome_studente TEXT,
    __matricola_studente CHAR(6),
    __voto INTEGER,
    __valida BOOLEAN,
    __media NUMERIC
  )
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

-- restituisce tutte le valutazioni e le carriere di ex studenti
CREATE OR REPLACE FUNCTION get_ex_valutazioni ()
  RETURNS TABLE (
    __appello uuid,
    __insegnamento VARCHAR(6),
    __nome_insegnamento TEXT,
    __data DATE,
    __docente uuid,
    __nome_docente TEXT,
    __studente uuid,
    __nome_studente TEXT,
    __matricola_studente CHAR(6),
    __voto INTEGER,
    __valida BOOLEAN,
    __media NUMERIC
  )
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

-- restituisce gli esami mancanti per la laurea di tutti gli studenti
CREATE OR REPLACE FUNCTION get_esami_mancanti ()
  RETURNS TABLE (
    __studente uuid,
    __nome_studente TEXT,
    __matricola CHAR(6),
    __corso_di_laurea VARCHAR(6),
    __nome_corso_di_laurea TEXT,
    __codice VARCHAR(6),
    __nome TEXT,
    __descrizione TEXT,
    __anno ANNO_INSEGNAMENTO,
    __responsabile uuid,
    __nome_responsabile TEXT,
    __email_responsabile TEXT,
    __propedeuticita TEXT
  )
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

-- restituisce tutti gli insegnamenti di cui un docente è responsabile
CREATE OR REPLACE FUNCTION get_insegnamenti_per_docente (
  _id uuid
)
  RETURNS TABLE (
    __codice VARCHAR(6),
    __corso_di_laurea VARCHAR(6),
    __nome_corso_di_laurea TEXT,
    __nome TEXT,
    __descrizione TEXT,
    __anno ANNO_INSEGNAMENTO,
    __propedeuticita TEXT
  )
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

-- restituisce tutti gli appelli di insegnamenti di cui il docente è responsabile
CREATE OR REPLACE FUNCTION get_appelli_per_docente (
  _id uuid
)
  RETURNS TABLE (
    __codice uuid,
    __insegnamento VARCHAR(6),
    __nome_insegnamento TEXT,
    __data DATE,
    __ora TIME,
    __luogo TEXT,
    __da_valutare INTEGER
  )
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

-- restituisce tutti gli studenti iscritti agli appelli di un docente
CREATE OR REPLACE FUNCTION get_iscrizioni_per_docente (
  _id uuid
)
  RETURNS TABLE (
    __appello uuid,
    __insegnamento VARCHAR(6),
    __nome_insegnamento TEXT,
    __data DATE,
    __studente uuid,
    __matricola CHAR(6),
    __nome TEXT,
    __email TEXT
  )
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

-- restituisce tutte le valutazioni date da parte di un docente
CREATE OR REPLACE FUNCTION get_valutazioni_per_docente (
  _id uuid
)
  RETURNS TABLE (
    __appello uuid,
    __insegnamento VARCHAR(6),
    __nome_insegnamento TEXT,
    __data DATE,
    __studente uuid,
    __matricola CHAR(6),
    __nome TEXT,
    __email TEXT,
    __voto INTEGER
  )
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

-- restituisce tutti gli appelli di insegnamenti del corso di laurea dello studente
CREATE OR REPLACE FUNCTION get_appelli_per_studente (
  _id uuid
)
  RETURNS TABLE (
    __codice uuid,
    __insegnamento VARCHAR(6),
    __nome_insegnamento TEXT,
    __data DATE,
    __ora TIME,
    __luogo TEXT,
    __ultimo_voto INTEGER,
    __iscritto BOOLEAN
  )
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

-- restituisce la media delle valutazioni attive di uno studente
CREATE OR REPLACE FUNCTION get_media_per_studente (
  _id uuid
)
  RETURNS TABLE (
    __media NUMERIC
  )
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

-- restituisce tutte le valutazioni date ad uno studente
CREATE OR REPLACE FUNCTION get_valutazioni_per_studente (
  _id uuid
)
  RETURNS TABLE (
    __studente uuid,
    __appello uuid,
    __insegnamento VARCHAR(6),
    __nome_insegnamento TEXT,
    __data DATE,
    __docente uuid,
    __nome_docente TEXT,
    __voto INTEGER,
    __valida BOOLEAN,
    __media NUMERIC
  )
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

-- restituisce gli esami mancanti per la laurea di uno studente
CREATE OR REPLACE FUNCTION get_esami_mancanti_per_studente (
  _id uuid
)
  RETURNS TABLE (
    __codice VARCHAR(6),
    __nome TEXT,
    __descrizione TEXT,
    __anno ANNO_INSEGNAMENTO,
    __responsabile uuid,
    __nome_responsabile TEXT,
    __email_responsabile TEXT,
    __propedeuticita TEXT
  )
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

-- restituisce la media delle valutazioni attive di un ex studente
CREATE OR REPLACE FUNCTION get_media_per_ex_studente (
  _id uuid
)
  RETURNS TABLE (
    __media NUMERIC
  )
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

-- restituisce tutte le valutazioni date ad un ex studente
CREATE OR REPLACE FUNCTION get_valutazioni_per_ex_studente (
  _id uuid
)
  RETURNS TABLE (
    __studente uuid,
    __appello uuid,
    __insegnamento VARCHAR(6),
    __nome_insegnamento TEXT,
    __data DATE,
    __docente uuid,
    __nome_docente TEXT,
    __voto INTEGER,
    __valida BOOLEAN,
    __media NUMERIC
  )
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
