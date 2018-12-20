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
    if [ $RET -eq 1 ]; then
        do_main_menu
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_copy_global_conf "AU915_2dBi_indoor";;
            2) do_copy_global_conf "AU915_4dBi_outdoor";;
            3) do_copy_global_conf "EU868_2dBi_indoor";;
            4) do_copy_global_conf "EU868_4dBi_outdoor";;
            5) do_copy_global_conf "US915_2dBi_indoor";;
            6) do_copy_global_conf "US915_4dBi_outdoor";;
        esac
    fi
}

do_copy_global_conf() {
    cp /etc/lora-packet-forwarder/lorixone/global_conf_$1.json /etc/lora-packet-forwarder/global_conf.json
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

do_resize_root_fs() {
    dialog --title "Resize root FS" --msgbox "This will resize the root FS to utilize all available space. The gateway will reboot after which the resize process will start. Please note that depending the SD Card size, this will take some time during which the gateway cann be less responsive.\n\n
To monitor the root FS resize, you can use the following command:\ndf -h" 25 60

    clear
    echo "The gateway will now reboot!"
    /etc/init.d/resize-rootfs start
}

do_main_menu() {
    FUN=$(dialog --title "LoRa Gateway OS" --cancel-label "Quit" --menu "Configuration options:" 15 60 7 \
        1 "Set admin password" \
        2 "Configure channel-plan" \
        3 "Edit packet-forwarder config" \
        4 "Edit LoRa Gateway Bridge config" \
        5 "Restart packet-forwarder" \
        6 "Restart LoRa Gateway Bridge" \
        7 "Resize root FS" \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        clear
        return 0
    elif [ $RET -eq 0 ]; then
        case "$FUN" in
            1) do_setup_admin_password;;
            2) do_setup_channel_plan;;
            3) nano /etc/lora-packet-forwarder/global_conf.json && do_main_menu;;
            4) nano /etc/lora-gateway-bridge/lora-gateway-bridge.toml && do_main_menu;;
            5) do_restart_packet_forwarder;;
            6) do_restart_lora_gateway_bridge;;
            7) do_resize_root_fs;;
        esac
    fi
}

do_main_menu
