#!/bin/bash
login=pi
passwd=raspberry
console_timeout=60
prompt="pi@raspberrypi:"

target_login="# set timeout
    set timeout $console_timeout
    # start up console and login
    spawn screen /dev/ttyUSB0 115200
    send \"\r\"
    expect \"raspberrypi login: \"
    send \"$login\r\"
    expect \"Password: \"
    send \"$passwd\r\""

target_exit="expect \"$prompt\" 
    send \"exit\r\""
