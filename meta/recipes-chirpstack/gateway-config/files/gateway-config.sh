#!/bin/sh

do_main_menu() {
    while true
    do
		if [ ! -d /etc/chirpstack-network-server ]; then
			do_main_menu_base
		else
			do_main_menu_full
		fi
    done
}

do_main_menu_base() {
	VERSION=$(cat /etc/version)
	GATEWAY_ID=$(/usr/bin/gateway-id)
	RET=$?
	if [ ! $RET -eq 0 ]; then
		GATEWAY_ID="not configured"
	fi

	FUN=$(dialog --cr-wrap --title "ChirpStack Gateway OS" --cancel-label "Quit" --menu "Version:    $VERSION\nGateway ID: $GATEWAY_ID\n " 18 65 9 \
		1 "Setup LoRa concentrator shield" \
		2 "Edit ChirpStack Concentratord config" \
		3 "Edit ChirpStack Gateway Bridge config" \
		4 "Restart ChirpStack Concentratord" \
		5 "Restart ChirpStack Gateway Bridge" \
		6 "Configure WIFI" \
		7 "Set admin password" \
		8 "Flash concentrator MCU" \
		9 "Reload Gateway ID" \
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
			8) do_flash_concentrator_mcu;;
			9) ;;
		esac
	fi
}

do_main_menu_full() {
	VERSION=$(cat /etc/version)
	GATEWAY_ID=$(/usr/bin/gateway-id)
	RET=$?
	if [ ! $RET -eq 0 ]; then
		GATEWAY_ID="not configured"
	fi

	FUN=$(dialog --cr-wrap --title "ChirpStack Gateway OS" --cancel-label "Quit" --menu "Version:    $VERSION\nGateway ID: $GATEWAY_ID\n " 19 65 10 \
		1 "Setup LoRa concentrator shield" \
		2 "Edit ChirpStack Concentratord config" \
		3 "Edit ChirpStack Gateway Bridge config" \
		4 "Restart ChirpStack Concentratord" \
		5 "Restart ChirpStack Gateway Bridge" \
		6 "Enable / disable applications" \
		7 "Configure WIFI" \
		8 "Set admin password" \
		9 "Flash concentrator MCU" \
		10 "Reload Gateway ID" \
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
			6) do_applications_menu;;
			7) do_configure_wifi;;
			8) do_setup_admin_password;;
			9) do_flash_concentrator_mcu;;
			10) ;;
		esac
	fi
}

do_applications_menu() {
	NODE_RED="Enable Node-RED"
	source "/etc/default/node-red"
	if [ "${ENABLED}" -eq 1 ]; then
		NODE_RED="Disable Node-RED"
	fi

	FUN=$(dialog --title "Enable / disable applications" --menu "Applications:" 15 60 3 \
		1 "${NODE_RED}" \
	3>&1 1>&2 2>&3)
	RET=$?
	if [ $RET -eq 0 ]; then
		case "$FUN" in
			1) do_application_toggle_node_red;;
		esac
	fi
}

do_application_toggle_node_red() {
	source "/etc/default/node-red"
	if [ "${ENABLED}" -eq 1 ]; then
		sed -i "s/ENABLED=.*/ENABLED=0/" /etc/default/node-red
		/etc/init.d/node-red restart
		dialog --title "Node-RED" --msgbox "Node-RED application has been disabled." 5 60
	else
		sed -i "s/ENABLED=.*/ENABLED=1/" /etc/default/node-red
		/etc/init.d/node-red restart
		dialog --title "Node-RED" --msgbox "Node-RED application has been enabled and is starting (this might take a minute). Once started, you can access Node-RED at:\n\n  > http://[IP ADDRESS]:1880" 10 60
	fi
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
        8 "RAK        - RAK2287 (with GNSS)" \
        9 "RAK        - RAK831" \
        10 "RisingHF   - RHF0M301" \
        11 "Sandbox    - LoRaGo PORT" \
        12 "Semtech    - SX1280 (2.4 GHz)" \
        13 "Semtech    - SX1302 CoreCell" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_set_concentratord "sx1301" && do_setup_ic880a && do_prompt_concentrator_reset_pin "sx1301" && do_restart_chirpstack_concentratord;;
            2) do_set_concentratord "sx1301" && do_setup_ic980a && do_prompt_concentrator_reset_pin "sx1301" && do_restart_chirpstack_concentratord;;
            3) do_set_concentratord "sx1301" && do_setup_imst_lite && do_restart_chirpstack_concentratord;;
            4) do_set_concentratord "sx1301" && do_setup_pislora && do_restart_chirpstack_concentratord;;
            5) do_set_concentratord "sx1301" && do_setup_rak2245 && do_restart_chirpstack_concentratord;;
            6) do_set_concentratord "sx1301" && do_setup_rak2246 && do_restart_chirpstack_concentratord;;
            7) do_set_concentratord "sx1301" && do_setup_rak2246g && do_restart_chirpstack_concentratord;;
            8) do_set_concentratord "sx1302" && do_setup_rak2287 && do_restart_chirpstack_concentratord;;
            9) do_set_concentratord "sx1301" && do_setup_rak2245 && do_restart_chirpstack_concentratord;;
            10) do_set_concentratord "sx1301" && do_setup_rhf0m301 && do_enable_spi0_1cs_overlay;;
            11) do_set_concentratord "sx1301" && do_setup_lorago_port && do_restart_chirpstack_concentratord;;
            12) do_set_concentratord "2g4" && do_setup_semtech_2g4 && do_restart_chirpstack_concentratord;;
            13) do_set_concentratord "sx1302" && do_setup_semtech_corecell && do_restart_chirpstack_concentratord;;
        esac
    fi
}

do_flash_concentrator_mcu() {
    FUN=$(dialog --title "Flash concentrator MCU" --menu "Select shield:" 18 60 5 \
        1  "Semtech    - SX1280 (2.4 GHz)" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_flash_semtech_2g4;;
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
        2 "RU864" \
        3 "IN865" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "imst_ic880a_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            2) do_copy_concentratord_config "sx1301" "imst_ic880a_ru864" "" "ru864" "0" && do_copy_chirpstack_ns_config "ru864";;
            3) do_copy_concentratord_config "sx1301" "imst_ic880a_in865" "" "in865" "0" && do_copy_chirpstack_ns_config "in865";;
        esac
    fi
}

do_setup_pislora() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "AU915" \
        2 "EU868" \
        3 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_select_au915_block "sx1301" "pi_supply_lora_gateway_hat_au915" "";;
            2) do_copy_concentratord_config "sx1301" "pi_supply_lora_gateway_hat_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            3) do_select_us915_block "sx1301" "pi_supply_lora_gateway_hat_us915" "";;
        esac
    fi
}

do_setup_rak2245() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 4 \
        1 "AS923" \
        2 "AU915" \
        3 "EU868" \
        4 "IN865" \
        5 "US915" \
        6 "RU864" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "rak_2245_as923" "GNSS" "as923" "0" && do_copy_chirpstack_ns_config "as923";;
            2) do_select_au915_block "sx1301" "rak_2245_au915" "GNSS";;
            3) do_copy_concentratord_config "sx1301" "rak_2245_eu868" "GNSS" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            4) do_copy_concentratord_config "sx1301" "rak_2245_in865" "GNSS" "in865" "0" && do_copy_chirpstack_ns_config "in865";;
            5) do_select_us915_block "sx1301" "rak_2245_us915" "GNSS";;
            6) do_copy_concentratord_config "sx1301" "rak_2245_ru864" "GNSS" "ru864" "0" && do_copy_chirpstack_ns_config "ru864";;
        esac
    fi
}

do_setup_rak2246() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 4 \
        1 "AS923" \
        2 "AU915" \
        3 "EU868" \
        4 "IN865" \
        5 "US915" \
        6 "RU864" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "rak_2246_as923" "" "as923" "0" && do_copy_chirpstack_ns_config "as923";;
            2) do_select_au915_block "sx1301" "rak_2246_au915" "";;
            3) do_copy_concentratord_config "sx1301" "rak_2246_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            4) do_copy_concentratord_config "sx1301" "rak_2246_in865" "" "in865" "0" && do_copy_chirpstack_ns_config "in865";;
            5) do_select_us915_block "sx1301" "rak_2246_us915" "";;
            6) do_copy_concentratord_config "sx1301" "rak_2246_ru864" "" "ru864" "0" && do_copy_chirpstack_ns_config "ru864";;
        esac
    fi
}

do_setup_rak2246g() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 4 \
        1 "AS923" \
        1 "AU915" \
        3 "EU868" \
        4 "IN865" \
        5 "US915" \
        6 "RU864" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "rak_2246_as923" "GNSS" "as923" "0" && do_copy_chirpstack_ns_config "as923";;
            2) do_select_au915_block "sx1301" "rak_2246_au915" "GNSS";;
            3) do_copy_concentratord_config "sx1301" "rak_2246_eu868" "GNSS" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            4) do_copy_concentratord_config "sx1301" "rak_2246_in865" "GNSS" "in865" "0" && do_copy_chirpstack_ns_config "in865";;
            5) do_select_us915_block "sx1301" "rak_2246_us915" "GNSS";;
            6) do_copy_concentratord_config "sx1301" "rak_2246_ru864" "GNSS" "ru864" "0" && do_copy_chirpstack_ns_config "ru864";;
        esac
    fi
}

do_setup_rak2287() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 7 \
        1 "AS923" \
        2 "AU915" \
        3 "EU868" \
        4 "IN865" \
        5 "KR920" \
        6 "RU864" \
        7 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1302" "rak_2287_as923" "GNSS" "as923" "0" && do_copy_chirpstack_ns_config "as923";;
            2) do_select_au915_block "sx1302" "rak_2287_au915" "GNSS";;
            3) do_copy_concentratord_config "sx1302" "rak_2287_eu868" "GNSS" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            4) do_copy_concentratord_config "sx1302" "rak_2287_in865" "GNSS" "in865" "0" && do_copy_chirpstack_ns_config "in865";;
            5) do_copy_concentratord_config "sx1302" "rak_2287_kr920" "GNSS" "kr920" "0" && do_copy_chirpstack_ns_config "kr920";;
            6) do_copy_concentratord_config "sx1302" "rak_2287_ru864" "GNSS" "ru864" "0" && do_copy_chirpstack_ns_config "ru864";;
            7) do_select_us915_block "sx1302" "rak_2287_us915" "GNSS";;
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
            1) do_copy_concentratord_config "sx1301" "risinghf_rhf0m301_eu868" "" "eu868" "0" && do_copy_chirpstack_ns_config "eu868";;
            2) do_select_us915_block "sx1301" "risinghf_rhf0m301_us915" "";;
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

do_setup_semtech_2g4() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "ISM2400 (2.4GHz)" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "2g4" "semtech_sx1280z3dsfgw1" "" "ism2400" "0" && do_copy_chirpstack_ns_config "ism2400";;
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
    sed -i "s/CONCENTRATORD_VERSION=.*/CONCENTRATORD_VERSION=\"$1\"/" /etc/default/chirpstack-concentratord
}

do_prompt_concentrator_reset_pin() {
    # $1 concentratord version
    PIN=$(dialog --inputbox "Please enter the GPIO pin to which the concentrator reset is connected: " 8 60 \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_setup_concentrator_shield
    elif [ $RET -eq 0 ]; then
        do_set_concentrator_reset_pin "$1" "$PIN"
    fi
}

do_set_concentrator_reset_pin() {
    # $1 concentratord version
    # $2 reset pin
    sed -i "s/reset_pin=.*/reset_pin=$2/" /etc/chirpstack-concentratord/$1/global.toml
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
    FUN=$(dialog --title "Edit ChirpStack Concentratord config" --menu "Edit config file:" 15 60 3 \
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
    FUN=$(dialog --title "Edit ChirpStack Gateway Bridge config" --menu "Edit config file:" 14 60 2 \
        1 "Edit configuration file" \
        2 "MQTT connection wizard" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 0 ]; then
        case "$FUN" in
            1) nano /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml;;
            2) do_edit_chirpstack_gateway_bridge_config_mqtt_wizard;;
        esac
    fi
}

do_edit_chirpstack_gateway_bridge_config_mqtt_wizard() {
    # mqtt broker
    MQTT_BROKER=$(dialog --inputbox "Please enter the MQTT broker address (e.g. tcp://server:1883, ssl://server:8883): " 8 60 \
        3>&1 1>&2 2>&3)    
    RET=$?
    if [ $RET -eq 1 ]; then
        return;
    fi
    sed -i "s/server=.*/server=\"${MQTT_BROKER//\//\\/}\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml

    # ca cert
    dialog --yesno "Would you like to configure a CA certificate?" 6 60
    RET=$?
    if [ $RET -eq 0 ]; then
        touch /etc/chirpstack-gateway-bridge/ca.pem

        dialog --title "MQTT connection wizard" --msgbox "Enter the content of the CA certificate in the next screen and close the editor with Ctrl+X." 7 60
        sed -i "s/ca_cert=.*/ca_cert=\"\/etc\/chirpstack-gateway-bridge\/ca.pem\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
        nano /etc/chirpstack-gateway-bridge/ca.pem
    else
        sed -i "s/tls_cert=.*/tls_cert=\"\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
    fi

    # client cert
    dialog --yesno "Would you like to configure a client certificate?" 6 60
    RET=$?
    if [ $RET -eq 0 ]; then
        touch /etc/chirpstack-gateway-bridge/cert.pem
        touch /etc/chirpstack-gateway-bridge/key.pem

        dialog --title "MQTT connection wizard" --msgbox "Enter the content of the client-certificate in the next screen and close the editor with Ctrl+X." 7 60
        sed -i "s/tls_cert=.*/tls_cert=\"\/etc\/chirpstack-gateway-bridge\/cert.pem\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
        nano /etc/chirpstack-gateway-bridge/cert.pem

        dialog --title "MQTT connection wizard" --msgbox "Enter the content of the client-certificate key in the next screen and close the editor with Ctrl+X." 7 60
        sed -i "s/tls_key=.*/tls_key=\"\/etc\/chirpstack-gateway-bridge\/key.pem\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
        nano /etc/chirpstack-gateway-bridge/key.pem
    else
        sed -i "s/tls_cert=.*/tls_cert=\"\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
        sed -i "s/tls_key=.*/tls_key=\"\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
    fi
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
    sleep 1
}

do_flash_semtech_2g4() {
    dialog --title "Flash concentrator MCU" --msgbox "This will flash the MCU of the Semtech 2g4 concentrator module, after which the system will reboot." 7 60
    /opt/libloragw-2g4/gateway-utils/boot -d /dev/ttyACM0
    sleep 1
    dfu-util -a 0 -s 0x08000000:leave -t 0 -D /opt/libloragw-2g4/mcu_bin/rlz_fwm_gtw_2g4_01.00.01.bin
    sleep 3

    # We reboot as the serial interface might be recognized as ttyACM1 after
    # a reflash of the MCU. After reboot will will revert back to ttyACM0.
    reboot

    sleep 1
}

do_enable_spi0_1cs_overlay() {
	dialog --title "Enabling GPIO7" --msgbox "This will enable the spi0-1cs overlay in /boot/config.txt as the selected shield requires GPIO7, after which the system will reboot.\n\nComment this out in /boot/config.txt if using a different shield." 10 60
	sed -i "s/#dtoverlay=spi0-1cs/dtoverlay=spi0-1cs/" /boot/config.txt
	reboot

	sleep 1
}

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

do_main_menu
