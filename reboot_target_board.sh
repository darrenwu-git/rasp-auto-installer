#!/bin/bash
set -ex

. target_console.sh

reset_target() {
    # The GPIO 2 from raspberry pi2 wired to pi3 reset pin
    # Pull low to reset pi3
    if [ ! -d /sys/class/gpio/gpio2/ ];then
        echo 2 | sudo tee -a /sys/class/gpio/export
    fi

    echo out | sudo tee -a /sys/class/gpio/gpio2/direction
    echo 0 | sudo tee -a /sys/class/gpio/gpio2/value
    sleep 3
    echo 1 | sudo tee -a /sys/class/gpio/gpio2/value
}

close_screen_detach () {
    screen -X quit || true
}

reboot_target() {
    close_screen_detach
    expect << EOF
    $target_login
    expect $prompt
    send "sudo reboot\r"
    send_user "system reboot!"
    close
EOF
}

install_UC_image () {
    #FIXME
    serverip=10.101.46.183
    image_path=/mnt
    image=pi3-20160924-0.img.xz


    close_screen_detach
    expect -d << EOF
    $target_login
    send "\r"
    expect $prompt
    # temporarily set timeout to 10 mins
    # due to copy image takes more time
    set timeout 600
    send "scp $serverip:$image_path/$image ~/\r"
    expect "password:"
    send "$passwd\r"
    expect $prompt
    send "\r"
    expect $prompt
    send "xzcat ~/$image | sudo dd of=/dev/mmcblk0 bs=32M\r"
    send "\r\r"
    sleep 60
    # reset timeout to 1 min
    $target_exit
    set timeout 60
    close
EOF

}

#reboot_target
#reset_target

install_UC_image
