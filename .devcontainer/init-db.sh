#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE ROLE "vscode" WITH LOGIN SUPERUSER;
  CREATE DATABASE "vscode" OWNER "vscode";
EOSQL
echo "Created PostgreSQL role and database: vscode"
