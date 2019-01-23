#!/bin/sh

mkdir -p /var/lib/firstbootinit

do_init_postgresql() {
    if [ ! -f /var/lib/firstbootinit/postgresql_initdb ]; then
        /usr/bin/postgresql-setup initdb

        # fix to start postgresql
        echo "10.5" > /var/lib/postgresql/data/PG_VERSION

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

#        sudo -u postgres /usr/bin/psql -c "create role loraserver_ns with login password 'loraserver_ns';"
#        sudo -u postgres /usr/bin/psql -c "create role loraserver_as with login password 'loraserver_as';"
#        sudo -u postgres /usr/bin/psql -c "create database loraserver_ns with owner loraserver_ns";
#        sudo -u postgres /usr/bin/psql -c "create database loraserver_as with owner loraserver_as";
#        sudo -u postgres /usr/bin/psql loraserver_as -c "create extension pg_trgm;"
#        touch /var/lib/firstbootinit/postgresql_dbs_created

		sudo /etc/init.d/postgresql-server stop
        sudo rm -rf /var/lib/postgresql/data 
        sudo tar -xzf /etc/lora-packet-forwarder/rak831/dbs-data.tar.gz -C /var/lib/postgresql/
        sudo /etc/init.d/postgresql-server reload
        sudo /etc/init.d/postgresql-server start

        # wait until postgresql is accepting connections
        while ! sudo -u postgres /usr/bin/pg_isready -h localhost; do
            sleep 1
        done

		sudo /opt/lora-packet-forwarder/update_gwid.sh /etc/lora-packet-forwarder/global_conf.json
		
		id=`cat /etc/lora-packet-forwarder/global_conf.json | grep ID | cut -d '"' -f 4`

        sudo -u postgres /usr/bin/psql loraserver_ns -c "INSERT INTO gateway (gateway_id, created_at, updated_at,location,altitude,gateway_profile_id) VALUES ('\x$id','2019-01-11 11:18:45.582951+00','2019-01-11 11:18:45.582951+00','(0,0)',0,'dcb98245-13e6-49d8-93cb-09b6fa6b71fa');"
        sudo -u postgres /usr/bin/psql loraserver_as -c "INSERT INTO gateway (mac, created_at, updated_at,name,description,organization_id,ping,network_server_id) VALUES   ('\x$id','2019-01-11 11:18:45.582951+00','2019-01-11 11:18:45.582951+00','Box-gateway','CH-EU868',1,'f',1);"   

		sudo /etc/init.d/lora-packet-forwarder restart

		touch /var/lib/firstbootinit/postgresql_dbs_created

    fi
}


do_init_postgresql
do_init_postgresql_dbs

update-rc.d -f firstbootinit remove

