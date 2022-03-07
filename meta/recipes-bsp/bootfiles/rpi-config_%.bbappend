do_deploy:append() {
    echo "dtparam=spi=on" >>${DEPLOYDIR}/bootfiles/config.txt    
    echo "enable_uart=1" >>${DEPLOYDIR}/bootfiles/config.txt
    echo "dtparam=i2c1=on" >>${DEPLOYDIR}/bootfiles/config.txt
    echo "dtparam=i2c_arm=on" >>${DEPLOYDIR}/bootfiles/config.txt

    # Needed as some boards (e.g. RisingHF) use GPIO 7 for reset.
    echo "# Uncomment the line below when shield uses PIN26 as GPIO7" >>${DEPLOYDIR}/bootfiles/config.txt
    echo "#dtoverlay=spi0-1cs" >>${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy:append:raspberrypi3() {
    echo "core_freq=250" >>${DEPLOYDIR}/bootfiles/config.txt
    echo "dtoverlay=disable-bt" >>${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy:append:raspberrypi4() {
    echo "dtoverlay=disable-bt" >>${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy:append:raspberrypi0-wifi() {
    echo "dtoverlay=disable-bt" >>${DEPLOYDIR}/bootfiles/config.txt
}
