# dump Super-Unimia database:

# from "server@postgres.favo02.dev:5432" postgres server
username="server"
host="postgres.favo02.dev"
port="5432"

# schema only:
pg_dump \
  --username=$username \
  --host=$host \
  --port=$port \
  --dbname="unimia" \
  --file=./dump-schema-only.sql \
  --no-owner \
  --schema-only \
  --clean \
  --create \
  --if-exists

# data only:
pg_dump \
  --username=$username \
  --host=$host \
  --port=$port \
  --dbname="unimia" \
  --schema="unimia" \
  --file=./dump-data-only.sql \
  --no-owner \
  --data-only \
  --disable-triggers \
  --inserts
