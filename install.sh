#!/usr/bin/env bash
#-*- encoding: utf-8 -*-
#Installation script for config files

# Clone the repository
git clone https://github.com/erikkamph/config

# Check two variables installed and foreign_installed if they are already set in the environment
[[ ! -z "$installed" ]] && [[ ! -z "$foreign_installed" ]] && [[ ! -z "$native" ]] && [[ ! -z "$foreign" ]] && {
	read -p "Do you want to unset following variables? [installed, foreign_installed, native, foreign] (y/N)" ans
	case ans in
		[yY])
			unset foreign_installed
			;;
		[nN])
			exit 1
			;;
	esac
}

local installed foreign_installed foreign native tmp tmp2

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
	echo "ZSH or ZSH_CUSTOM environment variable is required when installing."
	echo "Installing oh-my-zsh..."
	wget -O - https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -
} || {
	echo "YAY! Installing..."
}

while read -r line;
do
    pacman -S --noconfirm "$line"
done << "$(native)"

# Install yay if the user hasn't installed
# yay since before running this script.
[[ -z "$(which yay)" ]] && {
    read -p "Do you want to install yay? (Y/n)" ans
    [[ "$ans" =~ [yY] ]] && {
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
    } || {
        read -p "yay is recommended for the external packages. Continue anyway? (y/N)" ans
        ([[ -z "$ans" ]] || [[ "$ans" =~ [Nn] ]]) && {
            echo "Aborting..."
            exit 1
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

