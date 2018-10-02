do_deploy_append() {
    echo "dtparam=spi=on" >>${DEPLOYDIR}/bcm2835-bootfiles/config.txt    
    echo "enable_uart=1" >>${DEPLOYDIR}/bcm2835-bootfiles/config.txt
}

do_deploy_append_raspberrypi3() {
    echo "core_freq=250" >>${DEPLOYDIR}/bcm2835-bootfiles/config.txt
    echo "dtoverlay=pi3-disable-bt" >>${DEPLOYDIR}/bcm2835-bootfiles/config.txt
}
