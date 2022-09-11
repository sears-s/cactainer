#!/bin/bash

# Install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git yay
cd yay
makepkg -sri --needed --noconfirm

# Install AUR packages
yay -S --removemake --cleanafter --nodiffmenu --answerclean A --noconfirm --mflags "--needed --noconfirm" vmware-horizon-client vmware-horizon-usb vmware-horizon-smartcard

# Install DoD certificates
mkdir /tmp/certs
cd /tmp/certs
wget https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/certificates_pkcs7_DoD.zip
unzip certificates_pkcs7_DoD.zip

# Clean leftovers
yay -Yc --noconfirm
sudo pacman -Rs --noconfirm $(pacman -Qdttq)
sudo pacman -Scc --noconfirm
rm -rf ~/.cache /tmp/yay /tmp/certs
