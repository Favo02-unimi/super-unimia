DROP FUNCTION unimia.login;

CREATE FUNCTION unimia.login(
  _email TEXT,
  _password TEXT
)
  RETURNS TABLE (
    __id uuid,
    __type text
  )
  LANGUAGE plpgsql
  AS $$
    BEGIN
      RETURN QUERY
        SELECT
          u.id,
          split_part(split_part(u.email, '@', 2), '.', 1)
        FROM unimia.utenti AS u
        WHERE u.email = _email
        AND u.password = _password;
    END;
  $$;
