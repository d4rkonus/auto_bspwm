#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

ruta=$(pwd)

tput civis
trap 'tput cnorm; exit' INT TERM EXIT

USER_HOME=$(eval echo ~$SUDO_USER)
ruta="$(pwd)"

check_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo -e "\n[!] Please run this script as root."
        exit 1
    fi
}

install_dependencies() {
    echo -e "\n[+] Instalando dependencias..."
    apt-get update -y >/dev/null 2>&1

    # Dependencias comunes
    apt-get install -y \
        build-essential git vim meson ninja-build \
        libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev \
        libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev \
        libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev \
        >/dev/null 2>&1

    # Polybar
    apt-get install -y \
        cmake cmake-data pkg-config python3-sphinx \
        libcairo2-dev libxcb1-dev libxcb-composite0-dev \
        python3-xcbgen xcb-proto libxcb-image0-dev \
        libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev \
        libpulse-dev libjsoncpp-dev libmpdclient-dev \
        libuv1-dev libnl-genl-3-dev \
        >/dev/null 2>&1

    # Picom
    apt-get install -y \
        meson libxext-dev libxcb-damage0-dev libxcb-xfixes0-dev \
        libxcb-render-util0-dev libxcb-render0-dev libxcb-present-dev \
        libpixman-1-dev libev-dev libdbus-1-dev libconfig-dev \
        libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev \
        libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev \
        libxcb-image0-dev libxcb-composite0-dev \
        >/dev/null 2>&1

    # Paquetes adicionales
    apt-get install -y \
        feh scrot scrub rofi xclip bat locate ranger wmname acpi \
        bspwm sxhkd imagemagick \
        >/dev/null 2>&1
}

bspwm_and_sxhkd(){
    echo -e "\n[+] Clonando repositorios de bspwm y sxhkd..."
    cd /home/$SUDO_USER/Downloads || exit 1
    git clone https://github.com/baskerville/bspwm.git >/dev/null
    git clone https://github.com/baskerville/sxhkd.git >/dev/null
    cd bspwm/
    make
    sudo make install
    cd ../sxhkd/
    make
    sudo make install
 
    sudo apt install bspwm

    mkdir ~/.config/bspwm
    mkdir ~/.config/sxhkd
    cd /home/$SUDO_USER/Downloads/bspwm/examples || exit 1
    cp bspwmrc ~/.config/bspwm/
    chmod +x ~/.config/bspwm/bspwmrc 
    cp sxhkdrc ~/.config/sxhkd/
    cd "$ruta" || exit 1
    cp "$ruta/config/sxhkdrc" ~/.config/sxhkd/
}

