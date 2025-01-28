#!/bin/bash

name=$(stephan)

apps_path="/tmp/apps.csv"


echo "/tmp/apps.csv" >> "/tmp/packages"

packages=$(/tmp/packages)

# Don't forget to replace "Phantas0s" by the username of your Github account
curl https://raw.githubusercontent.com/gerneentsprechendnah/arch_installer/refs/heads/master/apps.csv > $apps_path

pacman -Syu --noconfirm

rm -f /tmp/aur_queue

dialog --title "Let's go!" --msgbox \
"The system will now install everything you need.\n\n\
It will take some time.\n\n " \
13 60

c=0
echo "$packages" | while read -r line; do
    c=$(( "$c" + 1 ))

    dialog --title "Arch Linux Installation" --infobox \
    "Downloading and installing program $c out of $count: $line..." \
    8 70

    ((pacman --noconfirm --needed -S "$line" > /tmp/arch_install 2>&1) \
    || echo "$line" >> /tmp/aur_queue) \
    || echo "$line" >> /tmp/arch_install_failed

    if [ "$line" = "zsh" ]; then
        # Set Zsh as default terminal for our user
        chsh -s "$(which zsh)" "$name"
    fi

    if [ "$line" = "networkmanager" ]; then
        systemctl enable NetworkManager.service
    fi
done

