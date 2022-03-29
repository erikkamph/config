# config
![Screenshot of configuration](1648541004.png)

```
pacman -S "$(cat native_packages.txt | cut -d " " -f 1 | tr "\n" " ")"
```
The command above installs all the packages necessary for a fully functioning arch installation. This will install i3, rofi, rofi-calc, rofi-emoji, xorg, python, zsh and rxvt.
It will also install fonts such as Noto Sans and Noto Sans Emoji which is the standard font used for emojis and other text when not using nerd fonts.

```
yay -S "$(cat foreign_packages.txt | cut -d " " -f 1 | tr "\n" " ")"
```
The command above installs all the foreign packages. Packages such as webbrowsers, fonts for powerlevel-10k used in zsh and other programs.
A requirement to use the command above is that yay is installed on the system that which the packages shall be installed on.

