FROM centos:centos6
MAINTAINER Health Catalyst <imran.qureshi@healthcatalyst.com>

RUN yum -y update; yum clean all

RUN useradd postgres && \
    usermod -aG wheel postgres

# This brings in the client too
RUN yum -y install postgresql-server
# And install the contributed libraries too (just in case)
RUN yum -y install postgresql-contrib

# Postgresql version
ENV PG_VERSION 8.4
ENV PGVERSION 84

# Set the environment variables
ENV HOME /var/lib/pgsql
ENV PGDATA /var/lib/pgsql/data

# Install postgresql and run InitDB
# RUN rpm -vih https://download.postgresql.org/pub/repos/yum/$PG_VERSION/redhat/rhel-7-x86_64/pgdg-centos$PGVERSION-$PG_VERSION-2.noarch.rpm && \
#     yum update -y && \
#     yum install -y sudo \
#     pwgen \
#     postgresql$PGVERSION \
#     postgresql$PGVERSION-server \
#     postgresql$PGVERSION-contrib && \
#     yum clean all

# Copy
# COPY data/postgresql-setup /usr/pgsql-$PG_VERSION/bin/postgresql$PGVERSION-setup

# Working directory
WORKDIR /var/lib/pgsql

# Run initdb
# RUN /usr/pgsql-$PG_VERSION/bin/postgresql$PGVERSION-setup initdb

# Make it so it starts automatically
RUN /sbin/service postgresql initdb
RUN /sbin/chkconfig postgresql on

# COPY data/postgresql.conf /var/lib/pgsql/$PG_VERSION/data/postgresql.conf

RUN mkdir -p /var/lib/pgsql/$PG_VERSION/data && \
    chown -R postgres:postgres $PGDATA && \
    chown -R postgres:postgres $PGDATA/

# Change own user
# RUN mkdir -p /var/lib/pgsql/$PG_VERSION/data && \
#     chown -R postgres:postgres /var/lib/pgsql/$PG_VERSION/data/*     
#     chmod +x /usr/local/bin/postgresql.sh

# Set volume
VOLUME ["/var/lib/pgsql"]

# Note: depending on your network configuration, you might also have to change
# the postgres configuration files to allow certain IPs to access the database.
# These files are:
# /var/lib/pgsql/data/pg_hba.conf - Can be used to control which ips have
# access to the database.
# /var/lib/pgsql/data/postgresql.conf - Can be used to control the
# connections the database listens for.
# You also might have to edit IP tables (depending on your server and network
# configuration).
# Start it up

RUN service postgresql start || cat /var/lib/pgsql/pgstartup.log

# Set username
USER postgres

# RUN chmod u=rwx,g-rwx,o-rwx /var/lib/pgsql/$PG_VERSION/data

# RUN echo $PG_VERSION > "/var/lib/pgsql/$PG_VERSION/data/PG_VERSION"
# Run PostgreSQL Server
# CMD ["/bin/bash", "/usr/local/bin/postgresql.sh"]
    

