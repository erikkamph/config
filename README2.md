# config
![Screenshot of configuration](1648541004.png)

## Installation
```
pacman -S $(cat native_packages.txt | cut -d " " -f 1 | tr "\n" " ")
```
1. The command above installs all the packages necessary for a fully functioning arch installation. This will install i3, rofi, rofi-calc, rofi-emoji, xorg, python, zsh and rxvt.
It will also install fonts such as Noto Sans and Noto Sans Emoji which is the standard font used for emojis and other text when not using nerd fonts.
<br><br>
```
yay -S $(cat foreign_packages.txt | cut -d " " -f 1 | tr "\n" " ")
```
2. The command above installs all the foreign packages. Packages such as webbrowsers, fonts for powerlevel-10k used in zsh and other programs. A requirement to use the command above is that yay is installed on the system that which the packages shall be installed on.
<br><br>
```
cp Xresources ~/.Xresources && cp xinitrc ~/.xinitrc && cp zshrc ~/.zshrc && cp ohmyzsh-custom/* $ZSH_CUSTOM/ && cp -R config ~/.config
```
3. All of the above copies files to their respective location for easy installation and to quickly get up and running.

## Alternative installation
```
wget -O - https://raw.githubusercontent.com/erikkamph/config/main/install.sh | bash -s -
```
