#!/bin/bash
set -e

echo "🚀 INIT-DATA.SH started..."

if [[ -n "${POSTGRES_NON_ROOT_USER}" && -n "${POSTGRES_NON_ROOT_PASSWORD}" ]]; then
  echo "Checking if database '${POSTGRES_DB}' exists..."

  DB_EXISTS=$(psql -h macarons -U "$POSTGRES_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${POSTGRES_DB}'")

  if [[ "$DB_EXISTS" != "1" ]]; then
    echo "Creating database '${POSTGRES_DB}'..."
    psql -h macarons -U "$POSTGRES_USER" -d postgres -c "CREATE DATABASE ${POSTGRES_DB};"
  else
    echo "Database '${POSTGRES_DB}' already exists."
  fi

  echo "Checking if user '${POSTGRES_NON_ROOT_USER}' exists..."

  USER_EXISTS=$(psql -h macarons -U "$POSTGRES_USER" -d postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='${POSTGRES_NON_ROOT_USER}'")

  if [[ "$USER_EXISTS" == "1" ]]; then
    echo "User '${POSTGRES_NON_ROOT_USER}' already exists."
  else
    echo "Creating user '${POSTGRES_NON_ROOT_USER}'..."
    psql -h macarons -U "$POSTGRES_USER" -d postgres -v ON_ERROR_STOP=1 <<-EOSQL
      CREATE USER ${POSTGRES_NON_ROOT_USER} WITH PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';
      GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
EOSQL
    echo "User '${POSTGRES_NON_ROOT_USER}' was created."
  fi
else
  echo "Required environment variables are missing."
fi
