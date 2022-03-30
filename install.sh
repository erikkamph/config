#!/usr/bin/env bash
#-*- encoding: utf-8 -*-
#Installation script for config files

# Clone the repository where this script is unless it's already cloned
(
        (
                [[ -d "$(pwd)/config" ]] && [[ ! -d "$(pwd)/config/.git" ]]
        ) || (
                [[ -d "$(pwd)/config/.git" ]] &&
                [[  "$(cd "$(pwd)/config" && git remote get-url origin)" != "https://github.com/erikkamph/config.git" ]]
        ) || [[ ! -d "$(pwd)/config" ]]
) && {
    echo "Moving $(pwd)/config to $(pwd)/config.tmp...";
    mv "$(pwd)/config" "$(pwd)/config.tmp";
}
git clone https://github.com/erikkamph/config

# Check two variables installed and foreign_installed if they are already set in the environment
[[ ! -z "$installed" ]] && [[ ! -z "$foreign_installed" ]] && [[ ! -z "$native" ]] && [[ ! -z "$foreign" ]] && {
	read -p "Do you want to unset following variables? [installed, foreign_installed, native, foreign] (y/N)" ans;
	case ans in
		[yY])
			unset foreign_installed
			;;
		[nN])
			exit 1
			;;
	esac
}

# Set the location of two tmp files to be used when determining packages to install and packages not to install again.
installed="/tmp/installed_$(date +%s).txt"
foreign_installed="/tmp/foreign_$(date +%s).txt"

# Get a hold of native and foreign packages installed inside the system
pacman -Qn >> "$installed"
pacman -Qm >> "$foreign_installed"

# Get a list of non installed packages and reuse the variables instead of creating new variables
foreign="$(diff $foreign_installed $(pwd)/config/foreign_packages.txt | tail -n +2 | cut -d " " -f 2)"
native="$(diff $installed $(pwd)/config/native_packages.txt | tail -n +2 | cut -d " " -f 2)"

# Remove the temporary files
rm "$installed" "$foreign_installed"

# Check for environment variables ZSH and ZSH_CUSTOM
# one of them needs to be set in order for the script
# to continue with installation, otherwise noting
# will be changed on the system which this installation
# occurs on.
tmp="$(python -c "import os;print('' if 'ZSH_CUSTOM' not in os.environ else os.environ['ZSH_CUSTOM'])")"
tmp2="$(python -c "import os;print('' if 'ZSH' not in os.environ else os.environ['ZSH'])")"

# Test if the length of the variables,
# tmp which holds ZSH_CUSTOM,
# tmp2 which holds ZSH, 
# are zero characters, this means that
# we do not have ohmyzsh and need to
# install it.
[[ -z "$tmp" ]] && [[ -z "$tmp2" ]] && {
	echo "ZSH or ZSH_CUSTOM environment variable is required when installing.";
	echo "Installing oh-my-zsh...";
	wget -O - https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -;
} || {
	echo "YAY! Installing...";
}

while read -r line;
do
    pacman -S --noconfirm "$line"
done << "$(native)"

# Install yay if the user hasn't installed
# yay since before running this script.
[[ -z "$(which yay)" ]] && {
    read -p "Do you want to install yay? (Y/n)" ans;
    [[ "$ans" =~ [yY] ]] && {
        git clone https://aur.archlinux.org/yay.git;
        cd yay;
        makepkg -si;
    } || {
        read -p "yay is recommended for the external packages. Continue anyway? (y/N)" ans;
        ([[ -z "$ans" ]] || [[ "$ans" =~ [Nn] ]]) && {
            echo "Aborting...";
            exit 1;
        }
    }
}

# If the user chose to install yay previously or yay already was installed in the system
# read all the missing foreign packages and install them one by one
[[ ! -z "$(which yay)" ]] && {
    while read -r line;
    do
        yay -S --noconfirm $line
    done << "$(echo "$foreign")"
}

# Copy custom files that contain functions
# aliases for programs and other configuration
[[ -d "$ZSH/custom" ]] && {
    omzfiles=(aliases.zsh functions.zsh keybindings.zsh)
    for item in omzfiles
    do
        cp "$(pwd)/config/ohmyzsh-custom/$item" "$ZSH/custom/$item"
    done
}

# Installs generic files that has
# customization for how to startx
# as well as how the terminal and
# zsh shall appear
files=(Xresources xinitrc zshrc zshrc.pre-oh-my-zsh p10k.zsh)
for item in files
do
    [[ -f "$HOME/.$item" ]] && {
        read -p "Backup $HOME/.$item? (Y/n)" ans
        [[ "$ans" =~ [yY] ]] && {
            cp "$HOME/.$item" "$HOME/.$item.bak"
        }
    }
    cp "$(pwd)/config/$item" "$HOME/.$item"
done

# Installs the color scheme used
# by Xresources in the terminal
wget -O "$HOME/.FirefoxDev" https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/Xresources/FirefoxDev

# Checks if a local font directory exists
# If not it creates it and installs the
# fonts used in the config files for i3,
# rofi, powerlevel10k and such programs
([[ -d "$HOME/.local/share/fonts" ]] || {
        mkdir -p "$HOME/.local/share/fonts"
}) && {
    tmp3=$(pwd)
    cd "$HOME/.local/share/fonts";
    
    wget -O JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip;
    unzip JetBrainsMono.zip;
    rm JetBrainsMono.zip;
    
    nf=(MesloLGS%20NF%20Bold%20Italic.ttf MesloLGS%20NF%20Bold.ttf MesloLGS%20NF%20Italic.ttf MesloLGS%20NF%20Regular.ttf)
    for font in nf
    do
        font1="$(echo $font | sed -e "s/\%20/ /g")"
        wget -O "$font1" "https://github.com/romkatv/powerlevel10k-media/raw/master/$font"
    done
    
    fc-cache;
    
    cd "$tmp3"
}

# Change default shell on the user from the one that the user has currently to zsh
chsh -s /bin/zsh $(whoami)

# Restore any config file/folder that existed from before starting this script
[[ -e "$(pwd)/config.tmp" ]] && {
    echo "Restoring config directory moved earlier...";
    rm -rf "$(pwd)/config";
    mv "$(pwd)/config.tmp" "$(pwd)/config";
}
