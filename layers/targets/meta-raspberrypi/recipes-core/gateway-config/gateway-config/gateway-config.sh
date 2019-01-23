#!/bin/sh

do_setup_admin_password() {
    dialog --title "Setup admin password" --msgbox "You will be asked to enter a new password." 5 60
    passwd admin
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Setup admin password" --msgbox "Password has been changed succesfully." 5 60
        do_main_menu
    fi
}

do_setup_concentrator_shield() {
#    FUN=$(dialog --title "Setup LoRa concentrator shield" --menu "Select shield:" 15 60 4 \
#        1 "RAK      - RAK831 with GPS module" \
#        2 "RAK      - RAK831 without GPS module" \
#        3>&1 1>&2 2>&3)
#    RET=$?
#    if [ $RET -eq 1 ]; then
#        do_main_menu
#    elif [ $RET -eq 0 ]; then
#        case "$FUN" in
#            1) do_set_concentrator_reset_pin 17 && do_setup_channel_plan "rak831" ".gps";;
             do_set_concentrator_reset_pin 17 && do_setup_channel_plan "rak831" ""
#x        esac
#    fi
}
 
do_setup_channel_plan() {
    # $1: concentrator type
    # $2: config suffix, eg ".gps"
    FUN=$(dialog --title "Channel-plan configuration" --menu "Select the channel-plan:" 15 60 9 \
        1 "AS_923" \
        2 "AU_915_928" \
        3 "CN_470_510" \
        4 "EU_433" \
        5 "EU_863_870" \
        6 "IN_865_867" \
        7 "KR_920_923" \
        8 "RU_864_870" \
        9 "US_902_928" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_global_conf $1 "as_923" $2;;
            2) do_copy_global_conf $1 "au_915_928" $2;;
			3) do_copy_global_conf $1 "cn_470_510" $2;;
			4) do_copy_global_conf $1 "eu_433" $2;;
            5) do_copy_global_conf $1 "eu_863_870" $2;;
            6) do_copy_global_conf $1 "in_865_867" $2;;
			7) do_copy_global_conf $1 "kr_920_923" $2;;
			8) do_copy_global_conf $1 "ru_864_870" $2;;
			9) do_copy_global_conf $1 "us_902_928" $2;;
        esac
    fi
}

do_prompt_concentrator_reset_pin() {
    PIN=$(dialog --inputbox "To which pin is the concentrator reset connected: " 8 60 \
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
    cp /etc/lora-packet-forwarder/$1/global_conf.$2.json$3 /etc/lora-packet-forwarder/global_conf.json
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Channel-plan configuration" --msgbox "Channel-plan configuration has been copied." 5 60
        do_set_gateway_id
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
        do_main_menu
    fi

}

do_restart_lora_gateway_bridge() {
    monit restart lora-gateway-bridge
    RET=$?
    if [ $RET -eq 0 ]; then
        dialog --title "Restart LoRa Gateway Bridge" --msgbox "The LoRa Gateway Bridge has been restarted." 5 60
        do_main_menu
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
    if [ $RET -eq 0 ]; then
        do_main_menu
    fi
}

do_resize_root_fs() {
    dialog --title "Resize root FS" --msgbox "This will resize the root FS to utilize all available space. The gateway will reboot after which the resize process will start. Please note that depending the SD Card size, this will take some time during which the gateway cann be less responsive.\n\n
To monitor the root FS resize, you can use the following command:\ndf -h" 25 60

    clear
    echo "The gateway will now reboot!"
    /etc/init.d/resize-rootfs start
}

do_main_menu() {
    FUN=$(dialog --title "LoRa Gateway OS" --cancel-label "Quit" --menu "Configuration options:" 15 60 8 \
        1 "Set admin password" \
        2 "Setup RAK831 LoRa concentrator" \
        3 "Edit packet-forwarder config" \
        4 "Edit LoRa Gateway Bridge config" \
        5 "Restart packet-forwarder" \
        6 "Restart LoRa Gateway Bridge" \
        7 "Configure WIFI" \
        8 "Resize root FS" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        clear
        return 0
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_setup_admin_password;;
            2) do_setup_concentrator_shield;;
            3) nano /etc/lora-packet-forwarder/global_conf.json && do_main_menu;;
            4) nano /etc/lora-gateway-bridge/lora-gateway-bridge.toml && do_main_menu;;
            5) do_restart_packet_forwarder;;
            6) do_restart_lora_gateway_bridge;;
            7) do_configure_wifi;;
            8) do_resize_root_fs;;
        esac
    fi
}

do_main_menu
