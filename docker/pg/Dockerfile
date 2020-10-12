FROM postgres:12

# Silence debconf TERM messages
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections
RUN apt-get update && apt-get install -y \
      postgresql-plpython3-12 \
      python3-dev \
      python3-pip \
      # Utilities
      software-properties-common \
      apt-transport-https \
      ca-certificates \
      gnupg \
      wget

# Setup postgresql data dir and config
RUN mkdir /data/
RUN cat /usr/share/postgresql/postgresql.conf.sample > /data/postgresql.conf

# PostgreSQL ENV variables

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=cs186
ENV POSTGRES_HOST_AUTH_METHOD=password
ENV POSTGRES_DB=adventureworks
ENV PGDATA=/data/

ADD adventureworks.sql /opt/adventureworks.sql

# Add initialization scripts
ADD clean.sql /docker-entrypoint-initdb.d/001_clean.sql
ADD load_data.sh /docker-entrypoint-initdb.d/002_load_data.sh

RUN pg_lsclusters


VOLUME /data
EXPOSE 5432
