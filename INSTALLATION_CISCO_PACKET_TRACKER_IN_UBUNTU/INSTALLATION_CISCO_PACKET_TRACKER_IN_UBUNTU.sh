#!/bin/bash

# Script to install Cisco Packet Tracer 8.2.2 on Ubuntu 24.04+ or similar

# Exit on critical errors
set -e

# Define the Packet Tracer .deb file path
PT_DEB="$HOME/Music/Packet_Tracer822_amd64_signed.deb"

# Check if the .deb file exists
if [ ! -f "$PT_DEB" ]; then
    echo "Error: Packet Tracer .deb file not found at $PT_DEB"
    exit 1
fi

echo "Starting Packet Tracer installation..."

# Step 1: Update package lists
echo "Updating package lists..."
sudo apt update

# Step 2: Install required dependencies
echo "Installing dependencies: dialog, libgl1, libxcb-xinerama0, libxcb-xinerama0-dev, and more..."
sudo apt install -y dialog libgl1 libxcb-xinerama0 libxcb-xinerama0-dev libxcb1-dev \
    libxau-dev libxdmcp-dev x11proto-dev xorg-sgml-doctools

# Step 3: Purge any existing or broken Packet Tracer installations
if dpkg -l | grep -q packettracer; then
    echo "Removing existing or broken Packet Tracer package..."
    sudo dpkg --purge packettracer || true
fi

# Step 4: Install Packet Tracer, ignoring libgl1-mesa-glx dependency
echo "Installing Packet Tracer (ignoring deprecated libgl1-mesa-glx)..."
if ! sudo dpkg --ignore-depends=libgl1-mesa-glx -i "$PT_DEB"; then
    echo "dpkg failed, attempting to fix broken dependencies..."
    sudo apt --fix-broken install -y
fi

# Step 5: Clean up unused packages
echo "Cleaning up unused packages..."
sudo apt autoremove -y

echo "Installation complete! Launch Packet Tracer from the application menu or by typing: packettracer"

exit 0
