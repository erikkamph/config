# config

## Sections
1. [TODO list](#todo-list)
2. [Configuration information](#configuration-information)
    1. [Native packages](#native-packages)
    2. [Foreign packages](#foreign-packages)
    3. [Fonts](#fonts)
    4. [Information about installation](#information-about-installation)
3. [Screenshots and videos](#screenshots-and-videos)
    1. [Screenshots](#screenshots)
    2. [Videos](#videos)
4. [Installation](#installation)

### TODO list
- [ ] Implement a separate jgmenurc config for jgmenu when using sway with waybar
- [ ] Customize waybar with different colors and icons using the fonts defined below
- [ ] Define the customisation modules and fonts
- [ ] Write about the customisation
- [ ] Write about the installation script
- [ ] \*Something else i forgot\*

### Configuration information

#### Fonts
There are a variety of fonts used in the configuration of the custom linux build. There is a list of them in [fonts.txt](/fonts.txt), but below are some that are more a requirement if using this type of configuration. See the file where I note what fonts are available in pacman on arch. However for different distributions, you might need separate configuration according to the disrtibution. For example installing the fonts in `~/.local/share/fonts`.
- [JetBrainsMono NF](https://www.nerdfonts.com/font-downloads)
- [MesloLGS NF](https://github.com/romkatv/powerlevel10k-media)
- [Noto Sans](https://fonts.google.com/noto/fonts)

#### Information about installation

### Screenshots and videos
#### Screenshots
![Screenshot of configuration](1648541004.png)

#### Videos

### Installation
```
wget -O - https://raw.githubusercontent.com/erikkamph/config/main/install.sh | bash -s -
```

