#!/bin/bash

# Colours
greenColour="\e[1;32m"
endColour="\e[0m"
redColour="\e[1;31m"
blueColour="\e[1;34m"
yellowColour="\e[1;33m"
purpleColour="\e[1;35m"
turquoiseColour="\e[1;36m"
grayColour="\e[1;37m"

ruta="$(pwd)"

# Ocultar cursor
tput civis

# Restaurar cursor al salir
trap 'tput cnorm' EXIT
trap 'tput cnorm; exit 1' INT TERM

# Obtener home del usuario real
USER_HOME="${SUDO_USER:-$(whoami)}"

check_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo -e "\n${redColour}[!] Please run this script as root.${endColour}"
        exit 1
    fi
}

install_dependencies() {
    echo -e "\n${blueColour}[+] Instalando dependencias...${endColour}"
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

    echo -e "${greenColour}[✓] Dependencias instaladas.${endColour}"
}

bspwm_and_sxhkd() {
    echo -e "\n${blueColour}[+] Clonando repositorios de bspwm y sxhkd...${endColour}"
    cd "/home/$USER_HOME/Downloads" || exit 1

    git clone https://github.com/baskerville/bspwm.git >/dev/null 2>&1 || true
    git clone https://github.com/baskerville/sxhkd.git >/dev/null 2>&1 || true

    cd bspwm/ || exit 1
    make || { echo -e "${redColour}[!] Error compilando bspwm${endColour}"; exit 1; }
    sudo make install || { echo -e "${redColour}[!] Error instalando bspwm${endColour}"; exit 1; }

    cd ../sxhkd/ || exit 1
    make || { echo -e "${redColour}[!] Error compilando sxhkd${endColour}"; exit 1; }
    sudo make install || { echo -e "${redColour}[!] Error instalando sxhkd${endColour}"; exit 1; }

    # Crear configuraciones en el home del usuario
    mkdir -p "/home/$USER_HOME/.config/bspwm"
    mkdir -p "/home/$USER_HOME/.config/sxhkd"

    cd ../bspwm/examples || exit 1
    cp bspwmrc "/home/$USER_HOME/.config/bspwm/" || { echo -e "${redColour}[!] Error copiando bspwmrc${endColour}"; exit 1; }
    chmod +x "/home/$USER_HOME/.config/bspwm/bspwmrc"
    cp sxhkdrc "/home/$USER_HOME/.config/sxhkd/" || { echo -e "${redColour}[!] Error copiando sxhkdrc${endColour}"; exit 1; }
}

check_root
install_dependencies
bspwm_and_sxhkd