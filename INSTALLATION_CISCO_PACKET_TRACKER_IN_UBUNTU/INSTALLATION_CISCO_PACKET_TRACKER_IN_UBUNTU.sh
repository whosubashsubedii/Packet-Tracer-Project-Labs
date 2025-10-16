#!/bin/bash

# Packet Tracer 8.2.2 Installer for Ubuntu 24.04+
# Author: Subash Subedi
# Logs everything to ~/packettracer-install.log
# GUI messages (zenity) optional
# Auto shortcut creation

set -e

# --- Logging ---
LOGFILE="$HOME/packettracer-install.log"
# Ensure log file is writable by the user
touch "$LOGFILE" 2>/dev/null || LOGFILE="/tmp/packettracer-install.log"
exec > >(tee -a "$LOGFILE") 2>&1
echo "===== Starting Packet Tracer Installation: $(date) ====="

# --- GUI Support Check ---
zenity_installed=false
if command -v zenity >/dev/null 2>&1; then
    zenity_installed=true
fi

# --- Check for sudo (run early to ensure GUI works) ---
if ! sudo -n true 2>/dev/null; then
    echo "Error: This script requires sudo privileges."
    if $zenity_installed; then
        zenity --error --title="Permission Denied" \
            --text="Please run this script with sudo: sudo $0" \
            --no-wrap 2>/dev/null || echo "GUI error display failed."
    fi
    exit 1
fi

# --- Check version ---
if dpkg-query -W packettracer >/dev/null 2>&1; then
    INSTALLED_VERSION=$(dpkg-query -W -f='${Version}' packettracer)
    if [ "$INSTALLED_VERSION" == "8.2.2" ] && command -v packettracer >/dev/null 2>&1; then
        echo "Packet Tracer 8.2.2 is already installed and functional. Exiting."
        if $zenity_installed; then
            zenity --info --title="Packet Tracer Installer" \
                --text="Packet Tracer 8.2.2 is already installed." \
                --no-wrap 2>/dev/null
        fi
        exit 0
    fi
fi

# --- Directories to search ---
SEARCH_DIRS=(
    "$HOME/Desktop"
    "$HOME/Downloads"
    "$HOME/Music"
    "$HOME/Public"
    "$HOME/Documents"
    "$HOME/Pictures"
    "$HOME/Videos"
)

PT_DEB_NAME="Packet_Tracer822_amd64_signed.deb"

find_deb_file() {
    for dir in "${SEARCH_DIRS[@]}"; do
        if [ -f "$dir/$PT_DEB_NAME" ]; then
            echo "$dir/$PT_DEB_NAME"
            return 0
        fi
    done
    return 1
}

# --- Locate .deb file ---
if [ $# -eq 1 ]; then
    PT_DEB="$1"
    if [ ! -f "$PT_DEB" ]; then
        echo "Error: File not found: $PT_DEB"
        if $zenity_installed; then
            zenity --error --title="Installer Error" \
                --text="File not found: $PT_DEB" \
                --no-wrap 2>/dev/null
        fi
        exit 1
    fi
else
    PT_DEB=$(find_deb_file)
    if [ $? -ne 0 ]; then
        echo "Error: $PT_DEB_NAME not found in: ${SEARCH_DIRS[*]}"
        if $zenity_installed; then
            zenity --error --title="Installer Error" \
                --text="Could not find $PT_DEB_NAME in:\n${SEARCH_DIRS[*]}\nPlease move it to one of these directories or specify the path." \
                --no-wrap 2>/dev/null
        fi
        exit 1
    fi
fi

echo "Installing Packet Tracer from: $PT_DEB"

# --- Update packages ---
echo "Updating package list..."
sudo apt update

# --- Install dependencies ---
echo "Installing dependencies..."
sudo apt install -y dialog libgl1 libpng16-16 libqt5webkit5 libqt5multimedia5 \
    libqt5script5 libqt5svg5 libxcb-xinerama0 libxcb-xinerama0-dev libxcb1-dev \
    libpthread-stubs0-dev libxau-dev libxdmcp-dev x11proto-dev || {
    echo "Attempting to fix broken dependencies..."
    sudo apt --fix-broken install -y
    sudo apt install -y dialog libgl1 libpng16-16 libqt5webkit5 libqt5multimedia5 \
        libqt5script5 libqt5svg5 libxcb-xinerama0 libxcb-xinerama0-dev libxcb1-dev \
        libpthread-stubs0-dev libxau-dev libxdmcp-dev x11proto-dev
}

# --- Remove old versions ---
if dpkg -l | grep -q packettracer; then
    echo "Removing existing Packet Tracer..."
    sudo apt remove --purge -y packettracer || {
        echo "Warning: Could not fully remove Packet Tracer."
    }
fi

# --- Install .deb file ---
echo "Installing Packet Tracer..."
echo "Note: You may need to accept the Cisco EULA (use Tab/Enter)."
sudo dpkg --ignore-depends=libgl1-mesa-glx -i "$PT_DEB" || {
    echo "Fixing broken install..."
    sudo apt --fix-broken install -y
    sudo dpkg --ignore-depends=libgl1-mesa-glx -i "$PT_DEB"
}

# --- Configure if needed ---
if dpkg-query -W -f='${Status}' packettracer 2>/dev/null | grep -q "ok installed"; then
    echo "Packet Tracer installed and configured."
else
    echo "Attempting to configure Packet Tracer..."
    sudo dpkg --configure packettracer || {
        echo "Warning: Configuration may have failed, but installation may still be successful."
    }
fi

# --- Create desktop shortcut ---
DESKTOP_DIR="$HOME/Desktop"
DESKTOP_FILE="$DESKTOP_DIR/packettracer.desktop"
PT_DESKTOP="/usr/share/applications/pt.desktop"
if [ -d "$DESKTOP_DIR" ] && [ -f "$PT_DESKTOP" ]; then
    cp "$PT_DESKTOP" "$DESKTOP_FILE"
    chmod +x "$DESKTOP_FILE"
    chown "$SUDO_USER:$SUDO_USER" "$DESKTOP_FILE" 2>/dev/null || true
    echo "Shortcut created on Desktop: $DESKTOP_FILE"
elif [ ! -d "$DESKTOP_DIR" ]; then
    echo "Warning: Desktop directory ($DESKTOP_DIR) not found. Skipping shortcut creation."
elif [ ! -f "$PT_DESKTOP" ]; then
    echo "Warning: Packet Tracer desktop file ($PT_DESKTOP) not found. Skipping shortcut creation."
fi

# --- Skip autoremove ---
echo "Skipping autoremove to avoid dependency issues (libgl1-mesa-glx is ignored)."

# --- Final verification ---
if command -v packettracer >/dev/null 2>&1; then
    echo "Packet Tracer installation successful!"
    if $zenity_installed; then
        zenity --info --title="Installation Complete" \
            --text="Cisco Packet Tracer 8.2.2 was successfully installed!\n\nLaunch it from the menu or run: packettracer" \
            --no-wrap 2>/dev/null
    fi
else
    echo "Error: Packet Tracer not found in PATH."
    if $zenity_installed; then
        zenity --error --title="Installation Failed" \
            --text="Installation finished, but Packet Tracer was not found.\nTry running 'packettracer' in the terminal." \
            --no-wrap 2>/dev/null
    fi
    exit 1
fi

echo "===== Packet Tracer Installation Completed: $(date) ====="
exit 0
