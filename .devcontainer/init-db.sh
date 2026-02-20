#!/bin/bash
set -e

if [ -n "$HOST_USER" ]; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE ROLE "$HOST_USER" WITH LOGIN SUPERUSER;
    CREATE DATABASE "$HOST_USER" OWNER "$HOST_USER";
EOSQL
  echo "Created PostgreSQL role and database for: $HOST_USER"
fi
