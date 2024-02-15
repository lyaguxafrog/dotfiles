#!/bin/bash

# folders
rm -rf /home/$USER/dotfiles/docs
mkdir /home/$USER/Documents
mkdir /home/$USER/Downloads
mkdir /home/$USER/Music
mkdir /home/$USER/Pictures
mkdir /home/$USER/Videos

# yay
git clone https://aur.archlinux.org/yay.git /home/$USER/yay
cd /home/$USER/yay/
makepkg -si
cd /home/$USER/
rm -rf yay

# doas
sudo pacman -S doas
sudo cp /home/$USER/dotfiles/doas.conf /etc/conf
sudo chown -c root:root /etc/doas.conf
sudo chmod -c 0400 /etc/doas.conf

doas pacman -Rdd sudo
doas pacman -S --needed base-devel
doas pacman -R sudo

# packages
yay -S --needed wget polkit xorg xorg-xinit xorg-server xorg-xrandr xorg-xrdb rsync psmisc dunst nitrogen openbox rofi rxvt-unicode tint2 picom obmenu-generator perl-gtk3 pipewire lib32-pipewire pipewire-pulse pipewire-alsa helvum mpd mpc ncmpcpp alsa-utils brightnessctl imagemagick scrot w3m wireless_tools xclip xsettingsd xss-lock thunar thunar-archive-plugin thunar-volman ffmpegthumbnailer tumbler inkscape mpv parcellite pavucontrol viewnior xfce4-power-manager htop neofetch fish

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
wget --no-hsts -cN https://github.com/owl4ce/dotfiles/releases/download/ng/{Gladient_JfD,Papirus{,-Dark}-Custom}.tar.xz
tar -xf Gladient_JfD.tar.xz -C /home/$USER/.icons/
tar -xf Papirus-Custom.tar.xz -C /home/$USER/.icons/
tar -xf Papirus-Dark-Custom.tar.xz -C /home/$USER/.icons/
doas ln -vs /home/$USER/.icons/Papirus-Custom /usr/share/icons/
doas ln -vs /home/$USER/.icons/Papirus-Dark-Custom /usr/share/icons/


# urxvt
mkdir -pv /home/$USER/.urxvt/ext
(cd /home/$USER/.urxvt/ext/; curl -LO https://raw.githubusercontent.com/simmel/urxvt-resize-font/master/resize-font)
(cd /home/$USER/.urxvt/ext/; curl -LO https://raw.githubusercontent.com/mina86/urxvt-tabbedex/master/tabbedex)

# settings 
fc-cache -rv
rsync -avxHAXP --exclude-from=- /home/$USER/dotfiles/. /home/$USER/ << "EXCLUDE"
.git*
install.sh
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
clear
neofetch
echo "Done! Reboot! <3"
