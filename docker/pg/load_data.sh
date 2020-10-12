#!/bin/bash

# psql -U ${POSTGRES_USER} ${POSTGRES_DB} -c "CREATE DATABASE adventureworks;"
# psql -U ${POSTGRES_USER} ${POSTGRES_DB} adventureworks -c "DROP SCHEMA IF EXISTS public;"
pg_restore --verbose --if-exists --clean -d adventureworks -U postgres /opt/adventureworks.sql
psql -U ${POSTGRES_USER} ${POSTGRES_DB} adventureworks -c "SET max_parallel_workers_per_gather = 0;"
