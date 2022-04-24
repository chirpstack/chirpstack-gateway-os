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

        sudo -u postgres /usr/bin/psql -c "create role chirpstack with login password 'chirpstack';"
        sudo -u postgres /usr/bin/psql -c "create database chirpstack with owner chirpstack";
        sudo -u postgres /usr/bin/psql chirpstack -c "create extension pg_trgm;"
        sudo -u postgres /usr/bin/psql chirpstack -c "create extension hstore;"
        touch /var/lib/firstbootinit/postgresql_dbs_created
    fi
}

do_generate_ca_cert() {
    if [ ! -f /var/lib/firstbootinit/ca_cert_generated ]; then
        CERTROOT=/etc/chirpstack/certs
        cfssl gencert -initca $CERTROOT/ca-csr.json | cfssljson -bare $CERTROOT/ca
        cfssl gencert -ca $CERTROOT/ca.pem -ca-key $CERTROOT/ca-key.pem -config $CERTROOT/ca-config.json -profile server $CERTROOT/mqtt-server.json | cfssljson -bare $CERTROOT/mqtt-server
        chown mosquitto:mosquitto /$CERTROOT/mqtt*.pem

        touch /var/lib/firstbootinit/ca_cert_generated
    fi
}


do_init_postgresql
do_init_postgresql_dbs
do_generate_ca_cert

update-rc.d -f firstbootinit remove
