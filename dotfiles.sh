#!/bin/bash

if [[ $1 = 'install' ]]; then

    # folders
    rm -rf /home/$USER/dotfiles/docs
    mkdir /home/$USER/Documents
    mkdir /home/$USER/Downloads
    mkdir /home/$USER/Music
    mkdir /home/$USER/Pictures
    mkdir /home/$USER/Videos

    git clone https://github.com/lyaguxafrog/dotfiles /home/$USER/.dotfiles

    # yay
    git clone https://aur.archlinux.org/yay.git /home/$USER/yay
    cd /home/$USER/yay/
    makepkg -si
    cd /home/$USER/
    rm -rf yay

    # doas
    sudo pacman -S doas
    sudo cp /home/$USER/dotfiles/doas.conf /etc/doas.conf
    sudo chown -c root:root /etc/doas.conf
    sudo chmod -c 0400 /etc/doas.conf

    doas pacman -Rdd sudo
    doas pacman -S --needed base-devel
    doas pacman -R sudo

    # packages
    yay -S --needed wget polkit xorg xorg-xinit xorg-server xorg-xrandr xorg-xrdb rsync psmisc dunst nitrogen openbox rofi rxvt-unicode tint2 picom obmenu-generator perl-gtk3 pipewire lib32-pipewire pipewire-pulse pipewire-alsa helvum mpd mpc ncmpcpp alsa-utils brightnessctl imagemagick scrot w3m wireless_tools xclip xsettingsd xss-lock thunar thunar-archive-plugin thunar-volman ffmpegthumbnailer tumbler inkscape mpv parcellite pavucontrol viewnior xfce4-power-manager htop neofetch fish snixembed

    # fonts
    mkdir -pv /home/$USER/.fonts/{Cantarell,Comfortaa,IcoMoon-Custom,Nerd-Patched,Unifont}
    wget --no-hsts -cNP /home/$USER/.fonts/Comfortaa/ https://raw.githubusercontent.com/googlefonts/comfortaa/main/fonts/OTF/Comfortaa-{Bold,Regular}.otf
    wget --no-hsts -cNP /home/$USER/.fonts/IcoMoon-Custom/ https://github.com/owl4ce/dotfiles/releases/download/ng/{Feather,Material}.ttf
    wget --no-hsts -cNP /home/$USER/.fonts/Nerd-Patched/ https://github.com/owl4ce/dotfiles/releases/download/ng/M+.1mn.Nerd.Font.Complete.ttf
    wget --no-hsts -cNP /home/$USER/.fonts/Nerd-Patched/ https://github.com/owl4ce/dotfiles/releases/download/ng/{M+.1mn,Iosevka}.Nerd.Font.Complete.Mono.ttf
    wget --no-hsts -cNP /home/$USER/.fonts/Unifont/ https://unifoundry.com/pub/unifont/unifont-14.0.02/font-builds/unifont-14.0.02.ttf
    wget --no-hsts -cN https://download-fallback.gnome.org/sources/cantarell-fonts/0.303/cantarell-fonts-0.303.1.tar.xz
    tar -xvf cantarell*.tar.xz --strip-components 2 --wildcards -C /home/$USER/.fonts/Cantarell/ \*/\*/Cantarell-VF.otf

    yay -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-noto-nerd


    # icons
    mkdir -pv /home/$USER/.icons
    wget --no-hsts -cN https://github.com/lyaguxafrog/dotfiles/releases/download/icons/{Gladient_JfD,Papirus{,-Dark}-Custom}.tar.xz
    tar -xf Gladient_JfD.tar.xz -C /home/$USER/.icons/
    tar -xf Papirus-Custom.tar.xz -C /home/$USER/.icons/
    tar -xf Papirus-Dark-Custom.tar.xz -C /home/$USER/.icons/
    doas ln -vs /home/$USER/.icons/Papirus-Custom /usr/share/icons/
    doas ln -vs /home/$USER/.icons/Papirus-Dark-Custom /usr/share/icons/

    rm -rf Gladient_JfD.tar.xz
    rm -rf Papirus-Custom.tar.xz
    rm -rf Papirus-Dark-Custom.tar.xz

    # urxvt
    mkdir -pv /home/$USER/.urxvt/ext
    (cd /home/$USER/.urxvt/ext/; curl -LO https://raw.githubusercontent.com/simmel/urxvt-resize-font/master/resize-font)
    (cd /home/$USER/.urxvt/ext/; curl -LO https://raw.githubusercontent.com/mina86/urxvt-tabbedex/master/tabbedex)

    # settings 
    fc-cache -rv
    rsync -avxHAXP --exclude-from=- /home/$USER/dotfiles/. /home/$USER/ << "EXCLUDE"
.git*
dotfiles.sh
README.md
doas.conf
30-touchpad.conf
EXCLUDE

    echo "exec openbox-session" > /home/$USER/.xinitrc

    doas cp /home/$USER/dotfiles/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf

    # fish
    rm -f /home/$USER/.bashrc
    echo "exec fish" > /home/$USER/.bashrc

    # startup
    cp /home/$USER/.dotfiles/dotfiles.sh /home/$USER/.local/bin/dotfiles.sh && doas chmod +x /home/$USER/.local/bin/dotfiles.sh

    clear
    neofetch
    echo "Done! Reboot! <3"

fi

if [[ $1 = 'update' ]]; then
    # Start updating

    if [ ! -d "/home/$USER/.dotfiles" ]; then
        git clone https://github.com/lyaguxafrog/dotfiles /home/$USER/.dotfiles
    fi

    cd /home/$USER/.dotfiles
    git pull

    
    rsync -avxHAXP --exclude-from=- /home/$USER/.dotfiles/. ~/ << "EXCLUDE"
    .git*
    *.md
    *.joy
    settings.ini
    mpd.state
    autostart.sh
    environment
    tray
    eyecandy.rasi
    mechanical.rasi
    shared.rasi
    .gtkrc-2.0
    .joyfuld
    .Xresources
    doas.conf
    30-touchpad.conf
    dotfiles.sh
    docs/
EXCLUDE


    echo "Update complete!"
fi

if [[ $1 = 'uninstall' ]]; then
    read -p "Are you sure you want to uninstall dotfiles? [y/N] " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then

        echo "Uninstall packages :("

        # delete doas
        yay -S sudo base-devel
        sudo pacman -R doas && sudo rm -rf /etc/doas.conf

        # delete packages
        yay -Rdd polkit xorg xorg-xinit xorg-server xorg-xrandr xorg-xrdb rsync psmisc dunst nitrogen openbox rofi rxvt-unicode tint2 picom obmenu-generator perl-gtk3 pipewire lib32-pipewire pipewire-pulse pipewire-alsa helvum mpd mpc ncmpcpp alsa-utils brightnessctl imagemagick scrot w3m wireless_tools xclip xsettingsd xss-lock thunar thunar-archive-plugin thunar-volman ffmpegthumbnailer tumbler inkscape mpv parcellite pavucontrol viewnior xfce4-power-manager htop neofetch fish
        yay -Rdd noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-noto-nerd
        clear

        # delete fonts
        echo "Uninstall fonts :("
        rm -rf /home/$USER/.fonts/

        # delete icons
        echo "Uninstall icons :("
        rm -rf /home/$USER/.icons/


        echo "Clear .config :("
        rm -rf /home/$USER/.urxvt

        rm -rf /home/$USER/.config/dunst
        rm -rf /home/$USER/.config/fish
        rm -rf /home/$USER/.config/gtk-3.0
        rm -rf /home/$USER/.config/htop
        rm -rf /home/$USER/.config/inkscape
        rm -rf /home/$USER/.config/mpd
        rm -rf /home/$USER/.config/mpv
        rm -rf /home/$USER/.config/ncmpcpp
        rm -rf /home/$USER/.config/neofetch
        rm -rf /home/$USER/.config/obmenu-generator
        rm -rf /home/$USER/.config/openbox
        rm -rf /home/$USER/.config/parcelite
        rm -rf /home/$USER/.config/rofi
        rm -rf /home/$USER/.config/Thunar
        rm -rf /home/$USER/.config/tint2
        rm -rf /home/$USER/.config/viewnior
        rm -rf /home/$USER/.config/xfce4
        rm -rf /home/$USER/.config/picom.conf

        rm -rf /home/$USER/.wallpapers/
        rm -rf /home/$USER/.themes/
        rm -rf /home/$USER/.scripts/
        rm -rf /home/$USER/.config/
        
        find /home/$USER/.local/bin ! -name dotfiles.sh -type f -delete
        rm -rf /home/$USER/.local/share/ncmpcpp.album-art.desktop
        rm -rf /home/$USER/.local/share/ncmpcpp.desktop
        rm -rf /home/$USER/.local/share/ncmpcpp.single.allbum-art-desktop

        rm -rf /home/$USER/.bashrc && touch /home/$USER/.bashrc
        
        rm -rf /home/$USER/.dotfiles

        echo "Uninstallation complete :("
        echo "dotfiles.sh located in .local/bin/"
        echo "you can delete using: rm -rf /home/$USER/.local/bin/dotfiles.sh"
    else
        echo "Aborted."
    fi
fi
