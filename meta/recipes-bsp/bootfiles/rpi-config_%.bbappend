do_deploy_append() {
    echo "dtparam=spi=on" >>${DEPLOYDIR}/bootfiles/config.txt    
    echo "enable_uart=1" >>${DEPLOYDIR}/bootfiles/config.txt
    echo "dtparam=i2c1=on" >>${DEPLOYDIR}/bootfiles/config.txt
    echo "dtparam=i2c_arm=on" >>${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy_append_raspberrypi3() {
    echo "core_freq=250" >>${DEPLOYDIR}/bootfiles/config.txt
    echo "dtoverlay=disable-bt" >>${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy_append_raspberrypi4() {
    echo "dtoverlay=disable-bt" >>${DEPLOYDIR}/bootfiles/config.txt
}

do_deploy_append_raspberrypi0-wifi() {
    echo "dtoverlay=disable-bt" >>${DEPLOYDIR}/bootfiles/config.txt
}
