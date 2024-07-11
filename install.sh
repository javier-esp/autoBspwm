#!/bin/bash

# author: Javier Espantaleón

# global variables
dir=$(pwd)
user=$(whoami)

# colours
green="\e[38;2;136;255;37m"
red="\e[31m"
blue="\e[34m"
yellow="\e[33m"
purple="\e[35m"
end="\e[0m"

# ctrl + c
sig_int_handler() {
    echo -e "\n\n${red}[*] Exiting...${end}\n"
    exit 1
}

trap sig_int_handler INT

install_dependencies() {
    echo -e "${green}[+] Installing bspwm and sxhkd depenencies... \n${end}"
    sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev bspwm

    echo -e "${green}[+] Installing polybar and picom depenencies... \n${end}"    
    sudo apt install -y libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev

    cd /tmp
    wget https://hyperrealm.github.io/libconfig/dist/libconfig-1.7.3.tar.gz
    tar -xvf libconfig-1.7.3.tar.gz
    cd libconfig-1.7.3
    ./configure
    make
    sudo make install
}

install_bspwm() {
    echo -e "${green}\n[+] Installing bspwm...\n${end}"
    cd ~/Descargas
    cp -r $dir/config/bspwm/ ~/.config/
    sudo chmod +x ~/.config/bspwm/scripts/bspwm_resize
    git clone https://github.com/baskerville/bspwm.git
    cd bspwm
    make
    sudo make install
}

install_sxhkd() {
    echo -e "${green}\n[+] Installing sxhkd...\n${end}"
    cd ~/Descargas
    cp -r $dir/config/sxhkd/ ~/.config/
    git clone https://github.com/baskerville/sxhkd.git
    cd sxhkd
    make
    sudo make install
}

install_picom() {
    echo -e "${green}\n[+] Installing picom...\n${end}"
    cd ~/Descargas
    cp -r $dir/config/picom/ ~/.config/
    git clone https://github.com/yshui/picom.git
    cd picom
    meson setup --buildtype=release build
    ninja -C build
    ninja -C build install
}

install_rofi() {
    echo -e "${green}\n[+] Installing rofi...\n${end}"
    cd ~/Descargas
    cp -r $dir/config/rofi/ ~/.config/
    sudo apt install -y rofi
}

install_kitty() {
    echo -e "${green}\n[+] Installing kitty...\n${end}"
    cd ~/Descargas
    cp -r $dir/config/kitty/ ~/.config/
    wget https://github.com/kovidgoyal/kitty/releases/download/v0.35.2/kitty-0.35.2-x86_64.txz    
    sudo mkdir /opt/kitty
    sudo mv kitty-0.35.2-x86_64.txz /opt/kitty
    cd /opt/kitty
    sudo 7z x kitty-0.35.2-x86_64.txz
    sudo tar -xvf kitty-0.35.2-x86_64.tar
    sudo rm kitty-0.35.2-x86_64.txz
    sudo rm kitty-0.35.2-x86_64.tar
}

install_polybar() {
    echo -e "${green}\n[+] Installing Polybar...\n${end}"
    cd ~/Descargas
    cp -r $dir/config/polybar/ ~/.config/
    cp -r $dir/config/scripts/ ~/.config/
    sudo cp ~/.config/polybar/fonts* /usr/share/fonts/truetype/
    fc-cache -v
    sudo apt install -y polybar
}

install_zsh() {
    echo -e "${green}\n[+] Installing zsh and powerlevel10k...\n${end}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
    sudo apt install -y zsh zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting

    sudo usermod --shell /usr/bin/zsh root
    sudo usermod --shell /usr/bin/zsh $user
    cp $dir/.zshrc ~/
    cp $dir/.p10k.zsh ~/
    sudo cp -r ~/.powerlevel10k /root/
    sudo cp $dir/.zshrc /root/
    sudo cp $dir/.p10k.zsh /root/
}

install_fzf() {
    echo -e "${green}\n[+] Installing fzf...\n${end}"
    cd ~/Descargas
    sudo apt-get install -y expect
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install << EOF
    y   
EOF
}

install_bat() {
    echo -e "${green}\n[+] Installing bat..\n${end}"
    wget https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb
    sudo dpkg -i bat_0.24.0_amd64.deb
}

install_lsd() {
    echo -e "${green}\n[+] Installing lsd...\n${end}"
    wget https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd_1.1.2_amd64.deb
    sudo dpkg -i lsd_1.1.2_amd64.deb
}

set_fonts() {
    echo -e "${green}\n[+] Setting fonts...\n${end}"
    sudo cp -r $dir/fonts /usr/local/share/
    fc-cache -v
}

set_wallpaper() {
    echo -e "${green}\n[+] Setting wallpaper...\n${end}"
    sudo apt install -y feh
    cp -r $dir/config/wallpapers/ ~/.config/
}

banner="${green}
               __        ____                             
  ____ ___  __/ /_____  / __ )_________ _      ______ ___ 
 / __ \`/ / / / __/ __ \/ __  / ___/ __ \ | /| / / __ \`__ \\
/ /_/ / /_/ / /_/ /_/ / /_/ (__  ) /_/ / |/ |/ / / / / / /
\__,_/\__,_/\__/\____/_____/____/ .___/|__/|__/_/ /_/ /_/ 
                               /_/                        
${end}"

echo -e "$banner"

if [ "$USER" == "root" ]; then
    echo -e "\n\n${blue}[*] This script should not be run as root\n${end}"
    exit 1
fi

install_dependencies

install_bspwm

install_sxhkd

install_picom

install_rofi

install_kitty

install_polybar

install_zsh

install_fzf

install_bat

install_lsd

set_fonts

set_wallpaper

echo -e "\n${yellow}[+] Do you want to reboot your system? [y/n]: ${end}\n"
read answer

if [[ $answer == "y" || $answer == "Y" ]]; then
    echo -e "\n${blue}[+] Rebooting system...${end}"
    sleep 1
    sudo reboot
elif [[ $answer == "n" || $answer == "N" ]]; then
    echo -e "\n${blue}[+] System reboot cancelled${end}"
    exit 0
else
    echo "Invalid input."
    exit 1
fi