#!/bin/sh

mkdir -p /var/lib/firstbootinit

do_init_postgresql() {
    if [ ! -f /var/lib/firstbootinit/postgresql_initdb ]; then
        /usr/bin/postgresql-setup initdb

        # make sure we can connect using localhost
        sed -i 's/\(host.*all.*all.*\)ident/\1md5/g' /var/lib/postgresql/data/pg_hba.conf

        update-rc.d -f postgresql-server remove
        update-rc.d postgresql-server defaults
        /etc/init.d/postgresql-server start

        touch /var/lib/firstbootinit/postgresql_initdb
    fi
}

do_init_postgresql_dbs() {
    if [ ! -f /var/lib/firstbootinit/postgresql_dbs_created ]; then
        # wait until postgresql is accepting connections
        while ! sudo -u postgres /usr/bin/pg_isready -h localhost; do
            sleep 1
        done

        sudo -u postgres /usr/bin/psql -c "create role chirpstack_ns with login password 'chirpstack_ns';"
        sudo -u postgres /usr/bin/psql -c "create role chirpstack_as with login password 'chirpstack_as';"
        sudo -u postgres /usr/bin/psql -c "create database chirpstack_ns with owner chirpstack_ns";
        sudo -u postgres /usr/bin/psql -c "create database chirpstack_as with owner chirpstack_as";
        sudo -u postgres /usr/bin/psql chirpstack_as -c "create extension pg_trgm;"
        sudo -u postgres /usr/bin/psql chirpstack_as -c "create extension hstore;"
        touch /var/lib/firstbootinit/postgresql_dbs_created
    fi
}


do_init_postgresql
do_init_postgresql_dbs

update-rc.d -f firstbootinit remove
