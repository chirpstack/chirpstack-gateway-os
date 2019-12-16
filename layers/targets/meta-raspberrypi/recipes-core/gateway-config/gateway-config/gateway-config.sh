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

do_setup_concentrator_shield() {
    FUN=$(dialog --title "Setup LoRa concentrator shield" --menu "Select shield:" 15 60 8 \
        1 "IMST       - iC880A" \
        2 "IMST       - iC980A" \
        3 "Pi Supply  - LoRa Gateway HAT" \
        4 "RAK        - RAK2245" \
        5 "RAK        - RAK831" \
        6 "RisingHF   - RHF0M301" \
        7 "Sandbox    - LoRaGo PORT" \
        8 "Semtech    - SX1302 CoreCell" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_enable_sx1301 && do_prompt_concentrator_reset_pin && do_setup_ic880a;;
            2) do_enable_sx1301 && do_prompt_concentrator_reset_pin && do_setup_ic980a;;
            3) do_enable_sx1301 && do_set_concentrator_reset_pin 22 && do_setup_pislora;;
            4) do_enable_sx1301 && do_set_concentrator_reset_pin 17 && do_setup_rak831;;
            5) do_enable_sx1301 && do_set_concentrator_reset_pin 17 && do_setup_rak831;;
            6) do_enable_sx1301 && do_set_concentrator_reset_pin 7  && do_setup_rhf0m301;;
            7) do_enable_sx1301 && do_set_concentrator_reset_pin 25 && do_setup_lorago_port;;
            8) do_enable_sx1302 && do_setup_corecell;;
        esac
    fi
}

do_enable_sx1301() {
	monit stop lora-sx1302-hal-packet-forwarder

	# without configuration the SX1302 forwarder will not start
	rm -f /etc/lora-sx1302-hal-packet-forwarder/global_conf.json

	monit start lora-packet-forwarder
}

do_enable_sx1302() {
	monit stop lora-packet-forwarder

	# without configuration the SX1301 forwarder will not start
	rm -f /etc/lora-packet-forwarder/global_conf.conf

	monit start lora-sx1302-hal-packet-forwarder
}

do_setup_corecell() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "EU868" \
		2 "US915 (8 - 15)" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_sx1302_global_conf "corecell" "eu868" && do_copy_chirpstack_config "eu868";;
            2) do_copy_sx1302_global_conf "corecell" "us915_1" && do_copy_chirpstack_config "us915_1";;
        esac
    fi
}

do_setup_ic880a() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 1 \
        1 "EU868" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_global_conf "ic880a" "eu868" && do_copy_chirpstack_config "eu868";;
        esac
    fi
}

do_setup_ic980a() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 3 \
        1 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_select_us915_block "ic980a";;
        esac
    fi
}

do_setup_rak831() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 3 \
        1 "EU868" \
        2 "AU915" \
        3 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_global_conf "rak831" "eu868" && do_copy_chirpstack_config "eu868";;
            2) do_select_au915_block "rak831";;
            3) do_select_us915_block "rak831";;
        esac
    fi
}

do_setup_pislora() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "EU868" \
        3 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_global_conf "pislora" "eu868" && do_copy_chirpstack_config "eu868";;
            2) do_select_us915_block "pislora";;
        esac
    fi
}

do_setup_lorago_port() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "EU868" \
        2 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_global_conf "lorago_port" "eu868" && do_copy_chirpstack_config "eu868";;
            2) do_select_us915_block "lorago_port";;
        esac
    fi
}

do_select_us915_block() {
    # $1: concentrator type
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the US915 channel-block:" 15 60 8 \
        1 "Channels  0 -  7 + 64" \
        2 "Channels  8 - 15 + 65" \
        3 "Channels 16 - 23 + 66" \
        4 "Channels 24 - 31 + 67" \
        5 "Channels 32 - 39 + 68" \
        6 "Channels 40 - 47 + 69" \
        7 "Channels 48 - 55 + 70" \
        8 "Channels 56 - 64 + 71" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_global_conf $1 "us915_0" && do_copy_chirpstack_config "us915_0";;
            2) do_copy_global_conf $1 "us915_1" && do_copy_chirpstack_config "us915_1";;
            3) do_copy_global_conf $1 "us915_2" && do_copy_chirpstack_config "us915_2";;
            4) do_copy_global_conf $1 "us915_3" && do_copy_chirpstack_config "us915_3";;
            5) do_copy_global_conf $1 "us915_4" && do_copy_chirpstack_config "us915_4";;
            6) do_copy_global_conf $1 "us915_5" && do_copy_chirpstack_config "us915_5";;
            7) do_copy_global_conf $1 "us915_6" && do_copy_chirpstack_config "us915_6";;
            8) do_copy_global_conf $1 "us915_7" && do_copy_chirpstack_config "us915_7";;
        esac
    fi
}

do_select_au915_block() {
    # $1: concentrator type
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the AU915 channel-block:" 15 60 8 \
        1 "Channels  0 -  7 + 64" \
        2 "Channels  8 - 15 + 65" \
        3 "Channels 16 - 23 + 66" \
        4 "Channels 24 - 31 + 67" \
        5 "Channels 32 - 39 + 68" \
        6 "Channels 40 - 47 + 69" \
        7 "Channels 48 - 55 + 70" \
        8 "Channels 56 - 64 + 71" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_global_conf $1 "au915_0" && do_copy_chirpstack_config "au915_0";;
            2) do_copy_global_conf $1 "au915_1" && do_copy_chirpstack_config "au915_1";;
            3) do_copy_global_conf $1 "au915_2" && do_copy_chirpstack_config "au915_2";;
            4) do_copy_global_conf $1 "au915_3" && do_copy_chirpstack_config "au915_3";;
            5) do_copy_global_conf $1 "au915_4" && do_copy_chirpstack_config "au915_4";;
            6) do_copy_global_conf $1 "au915_5" && do_copy_chirpstack_config "au915_5";;
            7) do_copy_global_conf $1 "au915_6" && do_copy_chirpstack_config "au915_6";;
            8) do_copy_global_conf $1 "au915_7" && do_copy_chirpstack_config "au915_7";;
        esac
    fi
}

do_setup_rhf0m301() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "EU868" \
        2 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_global_conf "rhf0m301" "eu868" && do_copy_chirpstack_config "eu868";;
            2) do_copy_global_conf "rhf0m301" "us915" && do_copy_chirpstack_config "us915_0";;
        esac
    fi
}

do_prompt_concentrator_reset_pin() {
    PIN=$(dialog --inputbox "Please enter the GPIO pin to which the concentrator reset is connected: " 8 60 \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_setup_concentrator_shield
    elif [ $RET -eq 0 ]; then
        do_set_concentrator_reset_pin $PIN
    fi
}

do_set_concentrator_reset_pin() {
    sed -i "s/^\(CONCENTRATOR_RESET_PIN=\).*$/\1$1/" /etc/default/lora-packet-forwarder
}

do_copy_global_conf() {
    # $1 concentrator type
    # $2 channel-plan
    RET=0
    if [ -f /etc/lora-packet-forwarder/global_conf.json ]; then
        dialog --yesno "A packet-forwarder configuration file already exists. Do you want to overwrite it?" 6 60
        RET=$?
    fi

    if [ $RET -eq 0 ]; then
        cp /etc/lora-packet-forwarder/$1/global_conf.$2.json /etc/lora-packet-forwarder/global_conf.json
        RET=$?
        if [ $RET -eq 0 ]; then
            dialog --title "Channel-plan configuration" --msgbox "Channel-plan configuration has been copied." 5 60
            do_set_gateway_id
        fi
    fi
}

do_copy_sx1302_global_conf() {
    # $1 concentrator type
    # $2 channel-plan
    RET=0
    if [ -f /etc/lora-sx1302-hal-packet-forwarder/global_conf.json ]; then
        dialog --yesno "A packet-forwarder configuration file already exists. Do you want to overwrite it?" 6 60
        RET=$?
    fi

    if [ $RET -eq 0 ]; then
        cp /etc/lora-sx1302-hal-packet-forwarder/$1/global_conf.$2.json /etc/lora-sx1302-hal-packet-forwarder/global_conf.json
        RET=$?
        if [ $RET -eq 0 ]; then
            dialog --title "Channel-plan configuration" --msgbox "Channel-plan configuration has been copied." 5 60
			# TODO
            # do_set_sx1302_gateway_id
			do_restart_sx1302_packet_forwarder
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

do_restart_sx1302_packet_forwarder() {
    monit restart lora-sx1302-hal-packet-forwarder
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Restart packet-forwarder" --msgbox "The packet-forwarder has been restarted." 5 60
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

do_restart_chirpstack_gateway_bridge() {
    monit restart chirpstack-gateway-bridge
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Restart ChirpStack Gateway Bridge" --msgbox "The ChirpStack Gateway Bridge has been restarted." 5 60
    else
        exit $RET
    fi
}

do_configure_wifi() {
    dialog --title "Configure WIFI" --msgbox "This will open the 'connmanctl' utility to configure the WIFI." 5 75
    dialog --title "connmanctl quickstart" --msgbox "1) Enable wifi:\n
enable wifi\n\n
2) Scan available wifi networks:\n
scan wifi\n\n
3) Display available wifi networks:\n
services\n\n
4) Turn on agent:\n
agent on\n\n
5) Connect to network:\n
connect wifi_...\n\n
6) Quit connmanctl:\n
quit" 25 60
    clear
    connmanctl
    RET=$?
    if [ ! $RET -eq 0 ]; then
        exit $RET
    fi
}

do_main_menu() {
    while true
    do
        FUN=$(dialog --title "ChirpStack Gateway OS" --cancel-label "Quit" --menu "Configuration options:" 15 60 7 \
            1 "Set admin password" \
            2 "Setup LoRa concentrator shield" \
            3 "Edit packet-forwarder config" \
            4 "Edit ChirpStack Gateway Bridge config" \
            5 "Restart packet-forwarder" \
            6 "Restart ChirpStack Gateway Bridge" \
            7 "Configure WIFI" \
            3>&1 1>&2 2>&3)
        RET=$?
        if [ $RET -eq 1 ]; then
            clear
            exit 0
        elif [ $RET -eq 0 ]; then
            case "$FUN" in
                1) do_setup_admin_password;;
                2) do_setup_concentrator_shield;;
                3) nano /etc/lora-packet-forwarder/global_conf.json;;
                4) nano /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml;;
                5) do_restart_packet_forwarder;;
                6) do_restart_chirpstack_gateway_bridge;;
                7) do_configure_wifi;;
            esac
        fi
    done
}

do_main_menu
