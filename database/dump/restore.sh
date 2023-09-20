# restore Super-Unimia database from dump files:

# postgres server to import data into
username="postgres"
host="localhost"
port="5432"
# dbname should be the name of an existing database on the server
# it is required for a successfull connection
# the database restored will NOT be called as dbname
dbname="postgres"

psql \
  --username=$username \
  --host=$host \
  --port=$post \
  --dbname=$dbname \
    < dump-schema-only.sql

psql \
  --username=$username \
  --host=$host \
  --port=$post \
  --dbname="unimia" \
    < dump-data-only.sql
