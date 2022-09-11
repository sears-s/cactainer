# CACtainer

Container for accessing CAC enabled websites and VMWare Horizon. Useful for immutable distributions, such as Fedora Silverblue. Distrobox handles sharing USB devices, graphical applications, and setting up an init system for the container manager.

## Installation

Install distrobox using your distribution's package manager:

```bash
rpm-ostree install distrobox -r # example for Fedora Silverblue
```

In this directory, build the container image:

```bash
sudo podman build -t cactainer .
```

Disable and stop pcsc on the host:

```bash
sudo systemctl disable pcscd.socket
sudo systemctl stop pcscd.socket pcscd.service
```

Create a home directory for the container:

```bash
mkdir ~/cactainer
```

With your CAC in the reader, create the container:

```bash
distrobox create -i cactainer -n cactainer -H ~/cactainer -I -r
distrobox enter --root cactainer -- /post-install.sh
```

## Usage

To start CAC enabled Chromium:

```bash
distrobox enter --root cactainer -- chromium --incognito
```

To start CAC enabled VMWare Horizon:

```bash
distrobox enter --root cactainer -- vmware-view -s afrcdesktops.us.af.mil
```

Optionally, create aliases for these commands.

## Issues

On Fedora Silverblue 36, the user session crashes on the first `distrobox enter` and `distrobox rm` commands.

## Future Work

Ideally, these applications should be able to run in a rootless container or a Flatpak. This could be achieved by simply passing the pcsc socket from the host to the container. In this case, USB devices wouldn't need to be passed to the container and the container wouldn't need an init system. However, the pcsc server and client must share the same protocol. Red Hat patched pcsc-lite to support more smartcard readers which breaks interoperability with other distributions (see https://bugzilla.redhat.com/show_bug.cgi?id=2054826).
