#!/bin/sh

clear
echo "Installing needed packages...."
echo " "
sleep 1

cd $HOME
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

paru -S zsh hyprland discord rofi waybar-cava mako libnotify imagemagick zoxide eza ttf-jetbrains-mono rmpc ncmpcpp mpd cava pipe.sh tty-clock composer go rust neovim python paccache cups kitty mpv localsend-bin playerctl mpd-mpris mpc zsh-syntax-highlighting zsh-completions zsh-auto-venv-git zsh-autosuggestions atuin fzf rg jg poppler ffmpeg 7-zip wl-clipboard resvg libwebp libwebp-utils pipewire pipewire-pulse wireplumber jre-openjdk-headless noto-fonts noto-fonts-extra noto-fonts-cjk noto-fonts-emoji typy ufw iptables-nft man-db man-pages zip nwg-look brightnessctl

echo "Enabling some services...."
echo " "
sleep 1

systemctl enable --user mpd.service
sudo systemctl enable cups.service
sudo systemctl enable ufw.service
sudo ufw allow 53317/tcp
sudo ufw allow 53317/udp
ufw enable
systemctl enable --user mpd-mpris.service
systemctl enable --user pipewire.service
systemctl enable --user pipewire-pulse.service
systemctl enable --user wireplumber.service
systemctl enable --user pipewire-session-manager.service

echo "Copying folders...."
echo " "
sleep 1

mkdir $HOME/.config/gtk-2.0
mkdir $HOME/.config/gtk-3.0
mkdir $HOME/.config/gtk-4.0
mkdir $HOME/.config

cp -r $HOME/Dotfiles/nvim $HOME/.config
cp -r $HOME/Dotfiles/kitty $HOME/.config
cp -r $HOME/Dotfiles/mako $HOME/.config
cp -r $HOME/Dotfiles/fastfetch $HOME/.config
cp -r $HOME/Dotfiles/git $HOME/.config
cp -r $HOME/Dotfiles/hypr $HOME/.config
cp -r $HOME/Dotfiles/typy $HOME/.config
cp -r $HOME/Dotfiles/mpd $HOME/.config
cp -r $HOME/Dotfiles/rmpc $HOME/.config
cp -r $HOME/Dotfiles/ncmpcpp $HOME/.config
cp -r $HOME/Dotfiles/rofi $HOME/.config
cp -r $HOME/Dotfiles/waybar $HOME/.config
cp -r $HOME/Dotfiles/zsh $HOME/.config
cp -r $HOME/Dotfiles/mpv $HOME/.config

mkdir $HOME/.local
mkdir $HOME/.local/share
mkdir $HOME/.local/state

cp -r $HOME/Dotfiles/.local/share/albums $HOME/.local/share
cp -r $HOME/Dotfiles/.local/share/bin $HOME/.local/share
cp -r $HOME/Dotfiles/.local/share/fonts $HOME/.local/share
cp -r $HOME/Dotfiles/.local/share/icons $HOME/.local/share
cp -r $HOME/Dotfiles/.local/share/mpd $HOME/.local/share
cp -r $HOME/Dotfiles/.local/share/themes $HOME/.local/share

cp -r $HOME/Dotfiles/.local/state/mpd $HOME/.local/share

mkdir -p $HOME/Pictures/Screenshots

echo "Opening neovim...."
echo " "
sleep 1
nvim

echo "Configuring neovim overrides...."
sleep 1
cp -r $HOME/Dotfiles/.local/share/nvim $HOME/.local/share

echo "Setting themes...."
sleep 1
nwg-look

echo "Installation successfull!"
echo "Enjoy ricing!"
