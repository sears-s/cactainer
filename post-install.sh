#!/bin/bash

mkdir -p $HOME/.pki/nssdb/
modutil -force -dbdir sql:$HOME/.pki/nssdb/ -add "CAC Module" -libfile /usr/lib/opensc-pkcs11.so
for n in $(ls /certs/{*.p7b,*.pem}); do certutil -d sql:$HOME/.pki/nssdb -A -t TC -n $n -i $n; done
sudo rm -rf /certs/
