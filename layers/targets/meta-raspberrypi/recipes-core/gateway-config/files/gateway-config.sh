#!/bin/sh

do_main_menu() {
    while true
    do
        VERSION=$(cat /etc/version)
        GATEWAY_ID=$(/usr/bin/gateway-id)
        RET=$?
        if [ ! $RET -eq 0 ]; then
            GATEWAY_ID="not configured"
        fi

        FUN=$(dialog --cr-wrap --title "ChirpStack Gateway OS" --cancel-label "Quit" --menu "Version:    $VERSION\nGateway ID: $GATEWAY_ID\n " 17 65 7 \
            1 "Setup LoRa concentrator shield" \
            2 "Edit ChirpStack Concentratord config" \
            3 "Edit ChirpStack Gateway Bridge config" \
            4 "Restart ChirpStack Concentratord" \
            5 "Restart ChirpStack Gateway Bridge" \
            6 "Configure WIFI" \
            7 "Set admin password" \
            3>&1 1>&2 2>&3)
        RET=$?
        if [ $RET -eq 1 ]; then
            clear
            exit 0
        elif [ $RET -eq 0 ]; then
            case "$FUN" in
                1) do_setup_concentrator_shield;;
                2) do_edit_chirpstack_concentratord_config && do_restart_chirpstack_concentratord;;
                3) do_edit_chirpstack_gateway_bridge_config && do_restart_chirpstack_gateway_bridge;;
                4) do_restart_chirpstack_concentratord;;
                5) do_restart_chirpstack_gateway_bridge;;
                6) do_configure_wifi;;
                7) do_setup_admin_password;;
            esac
        fi
    done
}

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
    FUN=$(dialog --title "Setup LoRa concentrator shield" --menu "Select shield:" 18 60 11 \
        1 "IMST       - iC880A" \
        2 "IMST       - iC980A" \
        3 "IMST       - Lite Gateway" \
        4 "Pi Supply  - LoRa Gateway HAT" \
        5 "RAK        - RAK2245" \
        6 "RAK        - RAK2246" \
        7 "RAK        - RAK2246G (with GNSS)" \
        8 "RAK        - RAK831" \
        9 "RisingHF   - RHF0M301" \
        10 "Sandbox    - LoRaGo PORT" \
        11 "Semtech    - SX1302 CoreCell" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_set_concentratord "sx1301" && do_prompt_concentrator_reset_pin && do_setup_ic880a;;
            2) do_set_concentratord "sx1301" && do_prompt_concentrator_reset_pin && do_setup_ic980a;;
            3) do_set_concentratord "sx1301" && do_set_concentrator_reset_pin 5  && do_setup_imst_lite;;
            4) do_set_concentratord "sx1301" && do_set_concentrator_reset_pin 22 && do_setup_pislora;;
            5) do_set_concentratord "sx1301" && do_set_concentrator_reset_pin 17 && do_setup_rak2245;;
            6) do_set_concentratord "sx1301" && do_set_concentrator_reset_pin 17 && do_setup_rak2246;;
            7) do_set_concentratord "sx1301" && do_set_concentrator_reset_pin 17 && do_setup_rak2246g;;
            8) do_set_concentratord "sx1301" && do_set_concentrator_reset_pin 17 && do_setup_rak2245;;
            9) do_set_concentratord "sx1301" && do_set_concentrator_reset_pin 7  && do_setup_rhf0m301;;
            10) do_set_concentratord "sx1301" && do_set_concentrator_reset_pin 25 && do_setup_lorago_port;;
            11) do_set_concentratord "sx1302" && do_set_concentrator_reset_pin 23 && do_set_concentratord_power_en_pin 18 && do_setup_semtech_corecell;;
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
            1) do_copy_concentratord_config "sx1301" "imst_ic880a_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";
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
            1) do_select_us915_block "sx1301" "generic_eu868" "";;
        esac
    fi
}

do_setup_imst_lite() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 1 \
        1 "EU868" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "imst_ic880a_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";
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
            1) do_copy_concentratord_config "sx1301" "generic_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            2) do_select_us915_block "sx1301" "generic_us915" "";;
        esac
    fi
}

do_setup_rak2245() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 4 \
        1 "AS923" \
        1 "AU915" \
        3 "EU868" \
        4 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "rak_2245_as923" "GNSS" "as923" "0" && do_copy_chirpstack_ns_config "as923";;
            2) do_select_au915_block "sx1301" "rak_2245_au915" "GNSS";;
            3) do_copy_concentratord_config "sx1301" "rak_2245_eu868" "GNSS" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            4) do_select_us915_block "sx1301" "rak_2245_us915" "GNSS";;
        esac
    fi
}

do_setup_rak2246() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 4 \
        1 "AS923" \
        1 "AU915" \
        3 "EU868" \
        4 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "rak_2246_as923" "" "as923" "0" && do_copy_chirpstack_ns_config "as923";;
            2) do_select_au915_block "sx1301" "rak_2246_au915" "";;
            3) do_copy_concentratord_config "sx1301" "rak_2246_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            4) do_select_us915_block "sx1301" "rak_2246_us915" "";;
        esac
    fi
}

do_setup_rak2246g() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 4 \
        1 "AS923" \
        1 "AU915" \
        3 "EU868" \
        4 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "rak_2246_as923" "GNSS" "as923" "0" && do_copy_chirpstack_ns_config "as923";;
            2) do_select_au915_block "sx1301" "rak_2246_au915" "GNSS";;
            3) do_copy_concentratord_config "sx1301" "rak_2246_eu868" "GNSS" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            4) do_select_us915_block "sx1301" "rak_2246_us915" "GNSS";;
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
            1) do_copy_concentratord_config "sx1301" "generic_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            2) do_select_us915_block "sx1301" "generic_us915" "";;
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
            1) do_copy_concentratord_config "sx1301" "generic_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            2) do_select_us915_block "sx1301" "generic_us915" "";;
        esac
    fi
}

do_setup_semtech_corecell() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "EU868" \
        2 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1302" "semtech_sx1302c868gw1_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            2) do_select_us915_block "sx1302" "semtech_sx1302c915gw1_us915" "";;
        esac
    fi
}

do_select_us915_block() {
    # $1: concentratord version
    # $2: model
    # $3: model flags
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
            1) do_copy_concentratord_config "$1" "$2" "$3" "us915" "0" && do_copy_chirpstack_ns_config "us915_0";;
            2) do_copy_concentratord_config "$1" "$2" "$3" "us915" "1" && do_copy_chirpstack_ns_config "us915_1";;
            3) do_copy_concentratord_config "$1" "$2" "$3" "us915" "2" && do_copy_chirpstack_ns_config "us915_2";;
            4) do_copy_concentratord_config "$1" "$2" "$3" "us915" "3" && do_copy_chirpstack_ns_config "us915_3";;
            5) do_copy_concentratord_config "$1" "$2" "$3" "us915" "4" && do_copy_chirpstack_ns_config "us915_4";;
            6) do_copy_concentratord_config "$1" "$2" "$3" "us915" "5" && do_copy_chirpstack_ns_config "us915_5";;
            7) do_copy_concentratord_config "$1" "$2" "$3" "us915" "6" && do_copy_chirpstack_ns_config "us915_6";;
            8) do_copy_concentratord_config "$1" "$2" "$3" "us915" "7" && do_copy_chirpstack_ns_config "us915_7";;
        esac
    fi
}

do_select_au915_block() {
    # $1: concentratord version
    # $2: model
    # $3: model flags
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
            1) do_copy_concentratord_config "$1" "$2" "$3" "au915" "0" && do_copy_chirpstack_ns_config "au915_0";;
            2) do_copy_concentratord_config "$1" "$2" "$3" "au915" "1" && do_copy_chirpstack_ns_config "au915_1";;
            3) do_copy_concentratord_config "$1" "$2" "$3" "au915" "2" && do_copy_chirpstack_ns_config "au915_2";;
            4) do_copy_concentratord_config "$1" "$2" "$3" "au915" "3" && do_copy_chirpstack_ns_config "au915_3";;
            5) do_copy_concentratord_config "$1" "$2" "$3" "au915" "4" && do_copy_chirpstack_ns_config "au915_4";;
            6) do_copy_concentratord_config "$1" "$2" "$3" "au915" "5" && do_copy_chirpstack_ns_config "au915_5";;
            7) do_copy_concentratord_config "$1" "$2" "$3" "au915" "6" && do_copy_chirpstack_ns_config "au915_6";;
            8) do_copy_concentratord_config "$1" "$2" "$3" "au915" "7" && do_copy_chirpstack_ns_config "au915_7";;
        esac
    fi
}

do_set_concentratord() {
    monit stop chirpstack-concentratord
    sed -i "s/CONCENTRATORD_VERSION=.*/CONCENTRATORD_VERSION=\"$1\"/" /etc/default/chirpstack-concentratord
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
    sed -i "s/CONCENTRATOR_RESET=.*/CONCENTRATOR_RESET=\"yes\"/" /etc/default/chirpstack-concentratord
    sed -i "s/CONCENTRATOR_RESET_PIN=.*/CONCENTRATOR_RESET_PIN=$1/" /etc/default/chirpstack-concentratord
}

do_set_concentratord_power_en_pin() {
    sed -i "s/CONCENTRATOR_POWER_EN_PIN=.*/CONCENTRATOR_POWER_EN_PIN=$1/" /etc/default/chirpstack-concentratord
}

do_copy_concentratord_config() {
    # $1 concentratord version
    # $2 model
    # $3 model flags
    # $4 region
    # $5 sub-band
    RET=0
    if [ -f "/etc/chirpstack-concentratord/$1/global.toml" ] || [ -f "/etc/chirpstack-concentratord/$1/band.toml"] || [ -f "/etc/chirpstack-concentratord/$1/channels.toml" ]; then
        dialog --yesno "A ChirpStack Concentratord configuration file already exists. Do you want to overwrite it?" 6 60
        RET=$?
    fi

    if [ $RET -eq 0 ]; then
        cp /etc/chirpstack-concentratord/$1/examples/global.toml /etc/chirpstack-concentratord/$1/global.toml
        cp /etc/chirpstack-concentratord/$1/examples/$4.toml /etc/chirpstack-concentratord/$1/band.toml
        cp /etc/chirpstack-concentratord/$1/examples/$4_$5.toml /etc/chirpstack-concentratord/$1/channels.toml

        # set model
        sed -i "s/model=.*/model=\"${2}\"/" /etc/chirpstack-concentratord/$1/global.toml

        # set model flags
        IFS=' '; read -ra model_flags <<< $3
        model_flags_str=""
        for i in "${model_flags[@]}"; do model_flags_str="$model_flags_str\"$i\","; done
        sed -i "s/model_flags=.*/model_flags=[$model_flags_str]/" /etc/chirpstack-concentratord/$1/global.toml

        # set gateway id
        GWID_MIDFIX="fffe"
        GWID_BEGIN=""
        GWID_END=""

        ip link show eth0
        if [ $? -eq 0 ]; then
            GWID_BEGIN=$(ip link show eth0 | awk '/ether/ {print $2}' | awk -F\: '{print $1$2$3}')
            GWID_END=$(ip link show eth0 | awk '/ether/ {print $2}' | awk -F\: '{print $4$5$6}')
        else
            GWID_BEGIN=$(ip link show wlan0 | awk '/ether/ {print $2}' | awk -F\: '{print $1$2$3}')
            GWID_END=$(ip link show wlan0 | awk '/ether/ {print $2}' | awk -F\: '{print $4$5$6}')
        fi
        sed -i "s/gateway_id=.*/gateway_id=\"${GWID_BEGIN}${GWID_MIDFIX}${GWID_END}\"/" /etc/chirpstack-concentratord/$1/global.toml

        dialog --title "Channel-plan configuration" --msgbox "Channel-plan configuration has been copied." 5 60
    fi

    # We do need to restart because it was stopped when setting the concentratord
    # version (sx1301 or sx1302).
    do_restart_chirpstack_concentratord
}

do_copy_chirpstack_ns_config() {
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
        do_restart_chirpstack_ns
    fi
}

do_restart_chirpstack_ns() {
    monit restart chirpstack-network-server
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Restart ChirpStack Network Server" --msgbox "ChirpStack Network Server has been restarted." 5 60
    else
        exit $RET
    fi
}

do_edit_chirpstack_concentratord_config() {
    FUN=$(dialog --title "Edit ChirpStack Concentratord config" --menu "Select shield:" 15 60 3 \
        1 "General configuration" \
        2 "Beacon configuration" \
        3 "Channel configuration" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 0 ]; then
        source /etc/default/chirpstack-concentratord

        case "$FUN" in
            1) nano "/etc/chirpstack-concentratord/${CONCENTRATORD_VERSION}/global.toml";;
            2) nano "/etc/chirpstack-concentratord/${CONCENTRATORD_VERSION}/band.toml";;
            3) nano "/etc/chirpstack-concentratord/${CONCENTRATORD_VERSION}/channels.toml";;
        esac
    fi
}

do_edit_chirpstack_gateway_bridge_config() {
    nano /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
}

do_restart_chirpstack_concentratord() {
    monit restart chirpstack-concentratord
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Restart ChirpStack Concentratord" --msgbox "The ChirpStack Concentratord has been restarted." 5 60
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
    NAME=$(dialog --title "Configure WIFI" --inputbox "Please enter the name of WiFi network: " 8 60 \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ ! $RET -eq 0 ]; then
        do_main_menu
    fi

    PASSWORD=$(dialog --title "Configure WIFI" --inputbox "Please enter the password: " 8 60 \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ ! $RET -eq 0 ]; then
        do_main_menu
    fi
    
    dialog --title "Configure WIFI" --msgbox "The system will reboot to apply the new configuration." 5 60

    cat > /var/lib/connman/wifi.config << EOF
[service_wifi]
Type=wifi
Name=$NAME
Passphrase=$PASSWORD
IPv4=dhcp
EOF

    sed -i "s/Tethering=true/Tethering=false/" /var/lib/connman/settings
    reboot
}

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

do_main_menu
