#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE TABLE IF NOT EXISTS outbox (
        id uuid DEFAULT gen_random_uuid(),
        aggregatetype text NOT NULL,
        aggregateid text NOT NULL,
        type text NOT NULL,
        payload jsonb
);
EOSQL
