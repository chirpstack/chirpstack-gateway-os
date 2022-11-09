#!/bin/sh

do_main_menu() {
    while true
    do
        if [ ! -d /etc/chirpstack ]; then
            do_main_menu_base
        else
            while :
            do
                if [ -f /var/lib/firstbootinit/postgresql_dbs_created ];  then
                    break
                else
                    dialog --infobox "The database is initializing. This might take a minute or two during the first boot. Please wait." 4 60
                    sleep 1
                fi
            done
            do_main_menu_full
        fi
    done
}

do_main_menu_base() {
    VERSION=$(cat /etc/chirpstack-gateway-os-version)
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
    VERSION=$(cat /etc/chirpstack-gateway-os-version)
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
        /etc/init.d/node-red stop
        sed -i "s/ENABLED=.*/ENABLED=0/" /etc/default/node-red
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
    FUN=$(dialog --title "Setup LoRa concentrator shield" --menu "Select shield:" 23 60 11 \
        1 "IMST       - iC880A" \
        2 "IMST       - iC980A" \
        3 "IMST       - Lite Gateway" \
        4 "Pi Supply  - LoRa Gateway HAT" \
        5 "RAK        - RAK2245" \
        6 "RAK        - RAK2246" \
        7 "RAK        - RAK2246G (with GNSS)" \
        8 "RAK        - RAK2287 (with GNSS)" \
        9 "RAK        - RAK5146 (with GNSS)" \
        10 "RAK        - RAK831" \
        11 "RisingHF   - RHF0M301" \
        12 "Sandbox    - LoRaGo PORT" \
        13 "Seeed      - WM1302" \
        14 "Semtech    - SX1280 (2.4 GHz)" \
        15 "Semtech    - SX1302 CoreCell (SX1302CXXXGW1)" \
        16 "Semtech    - SX1302 CoreCell (USB) (SX1302CSSXXXGW1)" \
        17 "Waveshare  - SX1302 LoRaWAN Gateway HAT" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_set_concentratord "sx1301" && do_setup_ic880a && do_prompt_concentrator_reset_pin "sx1301" && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            2) do_set_concentratord "sx1301" && do_setup_ic980a && do_prompt_concentrator_reset_pin "sx1301" && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            3) do_set_concentratord "sx1301" && do_setup_imst_lite && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            4) do_set_concentratord "sx1301" && do_setup_pislora && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            5) do_set_concentratord "sx1301" && do_setup_rak2245 && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            6) do_set_concentratord "sx1301" && do_setup_rak2246 && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            7) do_set_concentratord "sx1301" && do_setup_rak2246g && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            8) do_set_concentratord "sx1302" && do_setup_rak2287 && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            9) do_set_concentratord "sx1302" && do_setup_rak5146 && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            10) do_set_concentratord "sx1301" && do_setup_rak2245 && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            11) do_set_concentratord "sx1301" && do_setup_rhf0m301 && do_enable_spi0_1cs_overlay;;
            12) do_set_concentratord "sx1301" && do_setup_lorago_port && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            13) do_set_concentratord "sx1302" && do_setup_seeed_wm1302 && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            14) do_set_concentratord "2g4" && do_setup_semtech_2g4 && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            15) do_set_concentratord "sx1302" && do_setup_semtech_sx1302cxxxgw1 && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            16) do_set_concentratord "sx1302" && do_setup_semtech_sx1302cssxxxgw1 && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
            17) do_set_concentratord "sx1302" && do_setup_waveshare_sx1302_lorawan_gateway_hat && do_restart_chirpstack_concentratord && do_create_chirpstack_gateway;;
        esac
    fi
}

do_flash_concentrator_mcu() {
    FUN=$(dialog --title "Flash concentrator MCU" --menu "Select shield:" 18 60 5 \
        1  "Semtech    - SX1280 (2.4 GHz)" \
        2  "Semtech    - SX1302 CoreCell (SX1302CSSXXXGW1)" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_flash_semtech_2g4;;
            2) do_flash_semtech_sx1302cssxxxgw1;;
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
            1) do_copy_concentratord_config "sx1301" "imst_ic880a_eu868" "" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";
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
            1) do_select_us915_block "sx1301" "generic_us915" "";;
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
            1) do_copy_concentratord_config "sx1301" "imst_ic880a_eu868" "" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
            2) do_copy_concentratord_config "sx1301" "imst_ic880a_ru864" "" "ru864" "" && do_update_chirpstack_gw_bridge_topic_prefix "ru864";;
            3) do_copy_concentratord_config "sx1301" "imst_ic880a_in865" "" "in865" "" && do_update_chirpstack_gw_bridge_topic_prefix "in865";;
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
            2) do_copy_concentratord_config "sx1301" "pi_supply_lora_gateway_hat_eu868" "" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
            3) do_select_us915_block "sx1301" "pi_supply_lora_gateway_hat_us915" "";;
        esac
    fi
}

do_setup_rak2245() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 19 60 4 \
        1 "AS923" \
        2 "AS923-2" \
        3 "AS923-3" \
        4 "AS923-4" \
        5 "AU915" \
        6 "CN470" \
        7 "EU433" \
        8 "EU868" \
        9 "IN865" \
        10 "KR920" \
        11 "RU864" \
        12 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "rak_2245_as923" "GNSS" "as923" "" && do_update_chirpstack_gw_bridge_topic_prefix "as923";;
            2) do_copy_concentratord_config "sx1301" "rak_2245_as923" "GNSS" "as923" "2" && do_update_chirpstack_gw_bridge_topic_prefix "as923_2";;
            3) do_copy_concentratord_config "sx1301" "rak_2245_as923" "GNSS" "as923" "3" && do_update_chirpstack_gw_bridge_topic_prefix "as923_3";;
            4) do_copy_concentratord_config "sx1301" "rak_2245_as923" "GNSS" "as923" "4" && do_update_chirpstack_gw_bridge_topic_prefix "as923_4";;
            5) do_select_au915_block "sx1301" "rak_2245_au915" "GNSS";;
            6) do_select_cn470_block "sx1301" "rak_2245_cn470" "GNSS";;
            7) do_copy_concentratord_config "sx1301" "rak_2245_eu433" "GNSS" "eu433" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu433";;
            8) do_copy_concentratord_config "sx1301" "rak_2245_eu868" "GNSS" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
            9) do_copy_concentratord_config "sx1301" "rak_2245_in865" "GNSS" "in865" "" && do_update_chirpstack_gw_bridge_topic_prefix "in865";;
            10) do_copy_concentratord_config "sx1301" "rak_2245_kr920" "GNSS" "kr920" "" && do_update_chirpstack_gw_bridge_topic_prefix "kr920";;
            11) do_copy_concentratord_config "sx1301" "rak_2245_ru864" "GNSS" "ru864" "" && do_update_chirpstack_gw_bridge_topic_prefix "ru864";;
            12) do_select_us915_block "sx1301" "rak_2245_us915" "GNSS";;
        esac
    fi
}

do_setup_rak2246() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 18 60 4 \
        1 "AS923" \
        2 "AS923-2" \
        3 "AS923-3" \
        4 "AS923-4" \
        5 "AU915" \
        6 "EU433" \
        7 "EU868" \
        8 "IN865" \
        9 "KR920" \
        10 "RU864" \
        11 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "rak_2246_as923" "" "as923" "" && do_update_chirpstack_gw_bridge_topic_prefix "as923";;
            2) do_copy_concentratord_config "sx1301" "rak_2246_as923" "" "as923" "2" && do_update_chirpstack_gw_bridge_topic_prefix "as923_2";;
            3) do_copy_concentratord_config "sx1301" "rak_2246_as923" "" "as923" "3" && do_update_chirpstack_gw_bridge_topic_prefix "as923_3";;
            4) do_copy_concentratord_config "sx1301" "rak_2246_as923" "" "as923" "4" && do_update_chirpstack_gw_bridge_topic_prefix "as923_4";;
            5) do_select_au915_block "sx1301" "rak_2246_au915" "";;
            6) do_copy_concentratord_config "sx1301" "rak_2246_eu433" "" "eu433" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu433";;
            7) do_copy_concentratord_config "sx1301" "rak_2246_eu868" "" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
            8) do_copy_concentratord_config "sx1301" "rak_2246_in865" "" "in865" "" && do_update_chirpstack_gw_bridge_topic_prefix "in865";;
            9) do_copy_concentratord_config "sx1301" "rak_2246_kr920" "" "kr920" "" && do_update_chirpstack_gw_bridge_topic_prefix "kr920";;
            10) do_copy_concentratord_config "sx1301" "rak_2246_ru864" "" "ru864" "" && do_update_chirpstack_gw_bridge_topic_prefix "ru864";;
            11) do_select_us915_block "sx1301" "rak_2246_us915" "";;
        esac
    fi
}

do_setup_rak2246g() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 18 60 4 \
        1 "AS923" \
        2 "AS923-2" \
        3 "AS923-3" \
        4 "AS923-4" \
        5 "AU915" \
        6 "EU433" \
        7 "EU868" \
        8 "IN865" \
        9 "KR920" \
        10 "RU864" \
        11 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1301" "rak_2246_as923" "GNSS" "as923" "" && do_update_chirpstack_gw_bridge_topic_prefix "as923";;
            2) do_copy_concentratord_config "sx1301" "rak_2246_as923" "GNSS" "as923" "2" && do_update_chirpstack_gw_bridge_topic_prefix "as923_2";;
            3) do_copy_concentratord_config "sx1301" "rak_2246_as923" "GNSS" "as923" "3" && do_update_chirpstack_gw_bridge_topic_prefix "as923_3";;
            4) do_copy_concentratord_config "sx1301" "rak_2246_as923" "GNSS" "as923" "4" && do_update_chirpstack_gw_bridge_topic_prefix "as923_4";;
            5) do_select_au915_block "sx1301" "rak_2246_au915" "";;
            6) do_copy_concentratord_config "sx1301" "rak_2246_eu433" "GNSS" "eu433" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu433";;
            7) do_copy_concentratord_config "sx1301" "rak_2246_eu868" "GNSS" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
            8) do_copy_concentratord_config "sx1301" "rak_2246_in865" "GNSS" "in865" "" && do_update_chirpstack_gw_bridge_topic_prefix "in865";;
            9) do_copy_concentratord_config "sx1301" "rak_2246_kr920" "GNSS" "kr920" "" && do_update_chirpstack_gw_bridge_topic_prefix "kr920";;
            10) do_copy_concentratord_config "sx1301" "rak_2246_ru864" "GNSS" "ru864" "" && do_update_chirpstack_gw_bridge_topic_prefix "ru864";;
            11) do_select_us915_block "sx1301" "rak_2246_us915" "GNSS";;
        esac
    fi
}

do_setup_rak2287() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 18 60 7 \
        1 "AS923" \
        2 "AS923-2" \
        3 "AS923-3" \
        4 "AS923-4" \
        5 "AU915" \
        6 "EU433" \
        7 "EU868" \
        8 "IN865" \
        9 "KR920" \
        10 "RU864" \
        11 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1302" "rak_2287_as923" "GNSS" "as923" "" && do_update_chirpstack_gw_bridge_topic_prefix "as923";;
            2) do_copy_concentratord_config "sx1302" "rak_2287_as923" "GNSS" "as923" "2" && do_update_chirpstack_gw_bridge_topic_prefix "as923_2";;
            3) do_copy_concentratord_config "sx1302" "rak_2287_as923" "GNSS" "as923" "3" && do_update_chirpstack_gw_bridge_topic_prefix "as923_3";;
            4) do_copy_concentratord_config "sx1302" "rak_2287_as923" "GNSS" "as923" "4" && do_update_chirpstack_gw_bridge_topic_prefix "as923_4";;
            5) do_select_au915_block "sx1302" "rak_2287_au915" "GNSS";;
            6) do_copy_concentratord_config "sx1302" "rak_2287_eu433" "GNSS" "eu433" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu433";;
            7) do_copy_concentratord_config "sx1302" "rak_2287_eu868" "GNSS" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
            8) do_copy_concentratord_config "sx1302" "rak_2287_in865" "GNSS" "in865" "" && do_update_chirpstack_gw_bridge_topic_prefix "in865";;
            9) do_copy_concentratord_config "sx1302" "rak_2287_kr920" "GNSS" "kr920" "" && do_update_chirpstack_gw_bridge_topic_prefix "kr920";;
            10) do_copy_concentratord_config "sx1302" "rak_2287_ru864" "GNSS" "ru864" "" && do_update_chirpstack_gw_bridge_topic_prefix "ru864";;
            11) do_select_us915_block "sx1302" "rak_2287_us915" "GNSS";;
        esac
    fi
}

do_setup_rak5146() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 18 60 7 \
        1 "AS923" \
        2 "AS923-2" \
        3 "AS923-3" \
        4 "AS923-4" \
        5 "AU915" \
        6 "EU433" \
        7 "EU868" \
        8 "IN865" \
        9 "KR920" \
        10 "RU864" \
        11 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1302" "rak_5146_as923" "GNSS" "as923" "" && do_update_chirpstack_gw_bridge_topic_prefix "as923";;
            2) do_copy_concentratord_config "sx1302" "rak_5146_as923" "GNSS" "as923" "2" && do_update_chirpstack_gw_bridge_topic_prefix "as923_2";;
            3) do_copy_concentratord_config "sx1302" "rak_5146_as923" "GNSS" "as923" "3" && do_update_chirpstack_gw_bridge_topic_prefix "as923_3";;
            4) do_copy_concentratord_config "sx1302" "rak_5146_as923" "GNSS" "as923" "4" && do_update_chirpstack_gw_bridge_topic_prefix "as923_4";;
            5) do_select_au915_block "sx1302" "rak_5146_au915" "GNSS";;
            6) do_copy_concentratord_config "sx1302" "rak_5146_eu433" "GNSS" "eu433" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu433";;
            7) do_copy_concentratord_config "sx1302" "rak_5146_eu868" "GNSS" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
            8) do_copy_concentratord_config "sx1302" "rak_5146_in865" "GNSS" "in865" "" && do_update_chirpstack_gw_bridge_topic_prefix "in865";;
            9) do_copy_concentratord_config "sx1302" "rak_5146_kr920" "GNSS" "kr920" "" && do_update_chirpstack_gw_bridge_topic_prefix "kr920";;
            10) do_copy_concentratord_config "sx1302" "rak_5146_ru864" "GNSS" "ru864" "" && do_update_chirpstack_gw_bridge_topic_prefix "ru864";;
            11) do_select_us915_block "sx1302" "rak_5146_us915" "GNSS";;
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
            1) do_copy_concentratord_config "sx1301" "risinghf_rhf0m301_eu868" "" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
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
            1) do_copy_concentratord_config "sx1301" "generic_eu868" "" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
            2) do_select_us915_block "sx1301" "generic_us915" "";;
        esac
    fi
}

do_setup_seeed_wm1302() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "EU868" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1302" "seeed_wm1302_spi_eu868" "" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
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
            1) do_copy_concentratord_config "2g4" "semtech_sx1280z3dsfgw1" "" "ism2400" "" && do_update_chirpstack_gw_bridge_topic_prefix "ism2400";;
        esac
    fi
}

do_setup_semtech_sx1302cxxxgw1() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "EU868" \
        2 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1302" "semtech_sx1302c868gw1_eu868" "" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
            2) do_select_us915_block "sx1302" "semtech_sx1302c915gw1_us915" "";;
        esac
    fi
}

do_setup_semtech_sx1302cssxxxgw1() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "AS923" \
        2 "EU868" \
        3 "US915" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1302" "semtech_sx1302css923gw1_as923" "" "as923" "" && do_update_chirpstack_gw_bridge_topic_prefix "as923";;
            2) do_copy_concentratord_config "sx1302" "semtech_sx1302css868gw1_eu868" "" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
            3) do_select_us915_block "sx1302" "semtech_sx1302css915gw1_us915" "";;
        esac
    fi
}

do_setup_waveshare_sx1302_lorawan_gateway_hat() {
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 2 \
        1 "EU868" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "sx1302" "waveshare_sx1302_lorawan_gateway_hat_eu868" "" "eu868" "" && do_update_chirpstack_gw_bridge_topic_prefix "eu868";;
        esac
    fi
}

do_select_cn470_block() {
    # $1: concentratord version
    # $2: model
    # $3: model flags
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the CN470 channel-block:" 19 60 12 \
        1 "Channels  0 -  7" \
        2 "Channels  8 - 15" \
        3 "Channels 16 - 23" \
        4 "Channels 24 - 31" \
        5 "Channels 32 - 39" \
        6 "Channels 40 - 47" \
        7 "Channels 48 - 55" \
        8 "Channels 56 - 63" \
        9 "Channels 64 - 71" \
        10 "Channels 72 - 79" \
        11 "Channels 80 - 87" \
        12 "Channels 88 - 95" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "0" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_0";;
            2) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "1" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_1";;
            3) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "2" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_2";;
            4) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "3" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_3";;
            5) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "4" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_4";;
            6) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "5" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_5";;
            7) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "6" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_6";;
            8) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "7" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_7";;
            9) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "8" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_8";;
            10) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "9" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_9";;
            11) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "10" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_10";;
            12) do_copy_concentratord_config "$1" "$2" "$3" "cn470" "11" && do_update_chirpstack_gw_bridge_topic_prefix "cn470_11";;
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
        8 "Channels 56 - 63 + 71" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "$1" "$2" "$3" "us915" "0" && do_update_chirpstack_gw_bridge_topic_prefix "us915_0";;
            2) do_copy_concentratord_config "$1" "$2" "$3" "us915" "1" && do_update_chirpstack_gw_bridge_topic_prefix "us915_1";;
            3) do_copy_concentratord_config "$1" "$2" "$3" "us915" "2" && do_update_chirpstack_gw_bridge_topic_prefix "us915_2";;
            4) do_copy_concentratord_config "$1" "$2" "$3" "us915" "3" && do_update_chirpstack_gw_bridge_topic_prefix "us915_3";;
            5) do_copy_concentratord_config "$1" "$2" "$3" "us915" "4" && do_update_chirpstack_gw_bridge_topic_prefix "us915_4";;
            6) do_copy_concentratord_config "$1" "$2" "$3" "us915" "5" && do_update_chirpstack_gw_bridge_topic_prefix "us915_5";;
            7) do_copy_concentratord_config "$1" "$2" "$3" "us915" "6" && do_update_chirpstack_gw_bridge_topic_prefix "us915_6";;
            8) do_copy_concentratord_config "$1" "$2" "$3" "us915" "7" && do_update_chirpstack_gw_bridge_topic_prefix "us915_7";;
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
        8 "Channels 56 - 63 + 71" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_concentratord_config "$1" "$2" "$3" "au915" "0" && do_update_chirpstack_gw_bridge_topic_prefix "au915_0";;
            2) do_copy_concentratord_config "$1" "$2" "$3" "au915" "1" && do_update_chirpstack_gw_bridge_topic_prefix "au915_1";;
            3) do_copy_concentratord_config "$1" "$2" "$3" "au915" "2" && do_update_chirpstack_gw_bridge_topic_prefix "au915_2";;
            4) do_copy_concentratord_config "$1" "$2" "$3" "au915" "3" && do_update_chirpstack_gw_bridge_topic_prefix "au915_3";;
            5) do_copy_concentratord_config "$1" "$2" "$3" "au915" "4" && do_update_chirpstack_gw_bridge_topic_prefix "au915_4";;
            6) do_copy_concentratord_config "$1" "$2" "$3" "au915" "5" && do_update_chirpstack_gw_bridge_topic_prefix "au915_5";;
            7) do_copy_concentratord_config "$1" "$2" "$3" "au915" "6" && do_update_chirpstack_gw_bridge_topic_prefix "au915_6";;
            8) do_copy_concentratord_config "$1" "$2" "$3" "au915" "7" && do_update_chirpstack_gw_bridge_topic_prefix "au915_7";;
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
    if [ -f "/etc/chirpstack-concentratord/$1/global.toml" ] || [ -f "/etc/chirpstack-concentratord/$1/band.toml" ] || [ -f "/etc/chirpstack-concentratord/$1/channels.toml" ]; then
        dialog --yesno "A ChirpStack Concentratord configuration file already exists. Do you want to overwrite it?" 6 60
        RET=$?
    fi

    SUFFIX=""
    if [ "$5" != "" ]; then
        SUFFIX="_${5}"
    fi

    if [ $RET -eq 0 ]; then
        cp /etc/chirpstack-concentratord/$1/examples/concentratord.toml /etc/chirpstack-concentratord/$1/concentratord.toml
        cp /etc/chirpstack-concentratord/$1/examples/band_$4.toml /etc/chirpstack-concentratord/$1/band.toml
        cp /etc/chirpstack-concentratord/$1/examples/channels_$4$SUFFIX.toml /etc/chirpstack-concentratord/$1/channels.toml

        # set model
        sed -i "s/model=.*/model=\"${2}\"/" /etc/chirpstack-concentratord/$1/concentratord.toml

        # set model flags
        IFS=' '; read -ra model_flags <<< $3
        model_flags_str=""
        for i in "${model_flags[@]}"; do model_flags_str="$model_flags_str\"$i\","; done
        sed -i "s/model_flags=.*/model_flags=[$model_flags_str]/" /etc/chirpstack-concentratord/$1/concentratord.toml

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
        sed -i "s/gateway_id=.*/gateway_id=\"${GWID_BEGIN}${GWID_MIDFIX}${GWID_END}\"/" /etc/chirpstack-concentratord/$1/concentratord.toml

        dialog --title "Channel-plan configuration" --msgbox "Channel-plan configuration has been copied." 5 60
    fi
}

do_update_chirpstack_gw_bridge_topic_prefix() {
    # $1 topic prefix
    sed -i "s/event_topic_template=.*/event_topic_template=\"${1}\/gateway\/{{ .GatewayID }}\/event\/{{ .EventType }}\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
    sed -i "s/state_topic_template=.*/state_topic_template=\"${1}\/gateway\/{{ .GatewayID }}\/state\/{{ .StateType }}\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
    sed -i "s/command_topic_template=.*/command_topic_template=\"${1}\/gateway\/{{ .GatewayID }}\/command\/\#\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
    do_restart_chirpstack_gateway_bridge
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

    # region prefix
    dialog --title "Use region prefix" \
        --yesno "ChirpStack v4 added a region prefix to the MQTT topics.\nExample: eu868/gateway/[ID]/...\n\nNot all servers use this prefix. Does the server you are configuring use this prefix? If you answer No, the prefix will be removed from the configuration." 10 60 \
        3>&1 1>&2 2>&3
    RET=$?
    if [ $RET -eq 1 ];then
        sed -i "s/event_topic_template=.*/event_topic_template=\"gateway\/{{ .GatewayID }}\/event\/{{ .EventType }}\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
        sed -i "s/state_topic_template=.*/state_topic_template=\"gateway\/{{ .GatewayID }}\/state\/{{ .StateType }}\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
        sed -i "s/command_topic_template=.*/command_topic_template=\"gateway\/{{ .GatewayID }}\/command\/\#\"/" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
    fi

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

do_flash_semtech_sx1302cssxxxgw1() {
    dialog --title "Flash concentrator MCU" --msgbox "This will flash the MCU of the Semtech SX1302 CoreCell (SX1302CSSXXXGW1), after which the system will reboot." 7 60
    /opt/libloragw-sx1302/gateway-utils/boot -d /dev/ttyACM0
    sleep 1
    dfu-util -a 0 -s 0x08000000:leave -t 0 -D /opt/libloragw-sx1302/mcu_bin/rlz_010000_CoreCell_USB.bin
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

do_create_chirpstack_gateway() {
    if [ ! -d /etc/chirpstack ]; then
        return
    fi

    dialog --yesno "Do you want to create the gateway in ChirpStack?" 5 60
    RET=$?
    if [ ! $RET -eq 0 ]; then
        return
    fi

    GATEWAY_ID=""
    RETRY=0
    while :
    do
        RETRY=$((RETRY+1))
        dialog --infobox "Retrieving the Gateway ID (this can take a couple of seconds after a Concentratord restart)." 4 60
        sleep 1
        GATEWAY_ID=$(/usr/bin/gateway-id)
        RET=$?
        if [ $RET -eq 0 ]; then
            break
        else
            if [ $RETRY -ge 30 ]; then
                dialog --msgbox "Retrieving the Gateway ID failed. Please check your concentrator shield configuration." 6 60
                return
            fi
        fi
    done

    while :
    do
        CREATE_SQL="
            insert into gateway (
                gateway_id,
                tenant_id,
                created_at,
                updated_at,
                name,
                description,
                latitude,
                longitude,
                altitude,
                stats_interval_secs,
                tags,
                properties
            ) values (
                decode('$GATEWAY_ID', 'hex'),
                '52f14cd4-c6f1-4fbd-8f87-4025e1d49242',
                now(),
                now(),
                'RaspberryPi Gateway',
                '',
                0,
                0,
                0,
                30,
                '{}',
                '{}'
            )
            on conflict do nothing
        "

        PGPASSWORD=chirpstack psql -h localhost -U chirpstack chirpstack -c "$CREATE_SQL"
        RET=$?
        if [ $RET -eq 0 ]; then
            dialog --title "ChirpStack" --msgbox "The gateway has been created for you in ChirpStack :)" 5 60
            break
        else
            dialog --yesno "Creating the gateway in ChirpStack failed. The first time when you boot the ChirpStack Gateway OS it takes some time to initialize the database. Do you want to try again?" 8 60
            RET=$?
            if [ ! $RET -eq 0 ]; then
                break
            fi
        fi
    done
}

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

do_main_menu
