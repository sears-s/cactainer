FROM docker.io/library/archlinux:base-devel

# Install packages
RUN pacman -Syu --needed --noconfirm chromium ccid git nss opensc unzip wget

# Add user
ARG user=builder
RUN useradd --system --create-home $user && \
	echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Run setup script
ADD setup.sh /tmp/
RUN sudo chmod +x /tmp/setup.sh && \
	/tmp/setup.sh
