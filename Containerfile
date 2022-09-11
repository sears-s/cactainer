FROM docker.io/library/archlinux:base-devel

# Install packages
RUN pacman -Syu --needed --noconfirm chromium ccid git libxkbfile nss opensc unzip wget

# Download DoD certificates
RUN mkdir /certs/ && \
	wget https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/certificates_pkcs7_DoD.zip && \
	unzip -j certificates_pkcs7_DoD.zip -d /certs/ && \
	rm certificates_pkcs7_DoD.zip

# Add user
ARG user=builder
RUN useradd --system --create-home $user && \
	echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Run build script
ADD build.sh /tmp/
RUN sudo chmod +x /tmp/build.sh && \
	/tmp/build.sh

# Add post install script
ADD post-install.sh /
RUN sudo chmod +x /post-install.sh

# Start systemd
CMD [ "/sbin/init" ]
