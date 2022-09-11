#!/bin/bash

# Install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git yay
cd yay
makepkg -sri --needed --noconfirm

# Install AUR packages
yay -S --removemake --cleanafter --nodiffmenu --answerclean A --noconfirm --mflags "--needed --noconfirm" vmware-horizon-client vmware-horizon-smartcard

# Install DoD certificates
# https://gist.github.com/AfroThundr3007730/ba99753dda66fc4abaf30fb5c0e5d012
mkdir /tmp/certs/
cd /tmp/certs/
openssl pkcs7 -print_certs -in /certs/*.pem.p7b | awk 'BEGIN {c=0} /subject=/ {c++} {print > "cert." c ".pem"}'
for i in *.pem; do
	name=$(openssl x509 -noout -subject -in $i | awk -F '(=|= )' '{gsub(/ /, "_", $NF); print $NF}')
        mv $i ${name}.crt
done
sudo mv *.crt /etc/ca-certificates/trust-source/anchors/
sudo update-ca-trust extract

# Enable pcsc socket
sudo systemctl enable pcscd.socket

# VMWare smartcard library
sudo mkdir -p /usr/lib/vmware/view/pkcs11
sudo ln -s /usr/lib64/pkcs11/opensc-pkcs11.so /usr/lib/vmware/view/pkcs11/libopenscpkcs11.so

# Clean leftovers
yay -Yc --noconfirm
sudo pacman -Rs --noconfirm $(pacman -Qdttq)
sudo pacman -Scc --noconfirm
rm -rf ~/.cache/ /tmp/yay/ /tmp/certs/
