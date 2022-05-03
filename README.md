# Inspecting Postgres Query Planning

1. Download the IMDB dataset (packaged for postgres) from [here](https://home.gtf.fyi/files/imdb) (WARNING: this is ~1GB!)
2. Place this file (should be called `imdb`) into `docker/pg`
3. Start the database + pgadmin with `docker-compose up --build` (run from the root of this repository). This may take a few minutes because the IMDB database is fairly large and has many indices. You can tell this is done when you see output like the following:
    ```
    pg_1       | PostgreSQL init process complete; ready for start up.
    pg_1       |
    pg_1       | 2020-10-14 00:23:00.966 UTC [1] LOG:  starting PostgreSQL 12.4 (Debian 12.4-1.pgdg100+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 8.3.0-6) 8.3.0, 64-bit
    pg_1       | 2020-10-14 00:23:00.967 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
    pg_1       | 2020-10-14 00:23:00.967 UTC [1] LOG:  listening on IPv6 address "::", port 5432
    pg_1       | 2020-10-14 00:23:00.970 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
    pg_1       | 2020-10-14 00:23:00.987 UTC [116] LOG:  database system was shut down at 2020-10-14 00:23:00 UTC
    pg_1       | 2020-10-14 00:23:00.991 UTC [1] LOG:  database system is ready to accept connections
    ```
    
    You can now visit the pgAdmin interface at `http://localhost:8888`. The username is `notreal@cs186berkeley.net` and the password is `cs186`.
    
    The user/pass for the postgres database is `postgres`/`cs186`
    
4. Install the Python dependencies inside a virtual environment:
    ```bash
    $ python3 -m venv venv
    $ . venv/bin/activate
    (venv) $ pip install -r requirements.txt
    ```
5. Execute the sequence of queries in the provided file (from w/n the virtual environment):
    ```bash
    (venv) $ python run_query_sequence.py queries.sql
    ```
    
    Make sure your terminal is full-screen! The script will iterate through each statement in `queries.sql` and print out the query plan (where appropriate). Hit `ENTER` to advance to the next query. If you are on Linux or Mac, the script will also copy the query into your clipboard so you can paste it into the pgAdmin interface. For help on how to do this, see the [video](https://youtu.be/zik6j42m3m8)
