#!/bin/sh

do_setup_admin_password() {
    dialog --title "Setup admin password" --msgbox "You will be asked to enter a new password." 5 60
    passwd admin
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Setup admin password" --msgbox "Password has been changed succesfully." 5 60
    else
        exit $RET
    fi
}

do_setup_channel_plan() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 6 \
        1 "AU915 2dBi (indoor)" \
        2 "AU915 4dBi (outdoor)" \
        3 "EU868 2dBi (indoor)" \
        4 "EU868 4dBi (outdoor)" \
        5 "US915 2dBi (indoor)" \
        6 "US915 4dBi (outdoor)" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_global_conf "AU915_2dBi_indoor" && do_copy_chirpstack_config "au915_0";;
            2) do_copy_global_conf "AU915_4dBi_outdoor" && do_copy_chirpstack_config "au915_0";;
            3) do_copy_global_conf "EU868_2dBi_indoor" && do_copy_chirpstack_config "eu868";;
            4) do_copy_global_conf "EU868_4dBi_outdoor" && do_copy_chirpstack_config "eu868";;
            5) do_copy_global_conf "US915_2dBi_indoor" && do_copy_chirpstack_config "us915_0";;
            6) do_copy_global_conf "US915_4dBi_outdoor" && do_copy_chirpstack_config "us915_0";;
        esac
    fi
}

do_copy_global_conf() {
    RET=0
    if [ -f /etc/lora-packet-forwarder/global_conf.json ]; then
        dialog --yesno "A packet-forwarder configuration file already exists. Do you want to overwrite it?" 6 60
        RET=$?
    fi

    if [ $RET -eq 0 ]; then
        cp /etc/lora-packet-forwarder/lorixone/global_conf_$1.json /etc/lora-packet-forwarder/global_conf.json
        RET=$?
        if [ $RET -eq 0 ]; then
            dialog --title "Channel-plan configuration" --msgbox "Channel-plan configuration has been copied." 5 60
            do_set_gateway_id
        fi
    fi
}

do_copy_chirpstack_config() {
    # $1 channel plan
    if [ ! -d /etc/chirpstack-network-server ]; then
        return;
    fi

    RET=0
    if [ -f /etc/chirpstack-network-server/chirpstack-network-server.toml ]; then
        dialog --yesno "A ChirpStack Network Server configuration file already exists. Do you want to overwrite it?" 6 60
        RET=$?
    fi

    if [ $RET -eq 0 ]; then
        cp /etc/chirpstack-network-server/config/$1.toml /etc/chirpstack-network-server/chirpstack-network-server.toml
        do_restart_chirpstack
    fi
}

do_set_gateway_id() {
    /opt/lora-packet-forwarder/update_gwid.sh /etc/lora-packet-forwarder/global_conf.json
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Set Gateway ID" --msgbox "The Gateway ID has been set." 5 60
        do_restart_packet_forwarder
    fi
}

do_restart_packet_forwarder() {
    monit restart lora-packet-forwarder
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Restart packet-forwarder" --msgbox "The packet-forwarder has been restarted." 5 60
    else
        exit $RET
    fi
}

do_restart_chirpstack_gateway_bridge() {
    monit restart chirpstack-gateway-bridge
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Restart ChirpStack Gateway Bridge" --msgbox "The ChirpStack Gateway Bridge has been restarted." 5 60
    else
        exit $RET
    fi
}

do_restart_chirpstack() {
    monit restart chirpstack-network-server
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Restart ChirpStack Network Server" --msgbox "ChirpStack Network Server has been restarted." 5 60
    else
        exit $RET
    fi
}

do_main_menu() {
    while true
    do
        FUN=$(dialog --title "ChirpStack Gateway OS" --cancel-label "Quit" --menu "Configuration options:" 15 60 6 \
            1 "Set admin password" \
            2 "Configure channel-plan" \
            3 "Edit packet-forwarder config" \
            4 "Edit ChirpStack Gateway Bridge config" \
            5 "Restart packet-forwarder" \
            6 "Restart ChirpStack Gateway Bridge" \
            3>&1 1>&2 2>&3)
        RET=$?
        if [ $RET -eq 1 ]; then
            clear
            exit 0
        elif [ $RET -eq 0 ]; then
            case "$FUN" in
                1) do_setup_admin_password;;
                2) do_setup_channel_plan;;
                3) nano /etc/lora-packet-forwarder/global_conf.json;;
                4) nano /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml;;
                5) do_restart_packet_forwarder;;
                6) do_restart_chirpstack_gateway_bridge;;
            esac
        fi
    done
}

do_main_menu
