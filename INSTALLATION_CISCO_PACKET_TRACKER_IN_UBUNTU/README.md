

# Cisco Packet Tracer 8.2.2 Installation Script for Ubuntu 24.04+

This script automates the installation of Cisco Packet Tracer 8.2.2 on Ubuntu 24.04 or similar Debian-based systems. It handles dependency resolution, package installation, and cleanup steps, making the setup process smoother for users.

---

## Prerequisites

- Ubuntu 24.04 or later
- Cisco Packet Tracer 8.2.2 `.deb` installer downloaded  
- Internet access for installing required packages
- Basic terminal knowledge

---

## Steps Performed by the Script

1. **Check for Packet Tracer `.deb` File**  
   Verifies the file `Packet_Tracer822_amd64_signed.deb` exists at `~/Music/`.

2. **Update Package Lists**  
   Runs `apt update` to fetch the latest package information.

3. **Install Required Dependencies**  
   Installs packages such as `dialog`, `libgl1`, `libxcb-xinerama0`, and others needed by Packet Tracer.

4. **Remove Broken or Existing Installations**  
   Detects and purges any existing `packettracer` packages.

5. **Install Packet Tracer with dpkg**  
   Installs the `.deb` file while bypassing outdated `libgl1-mesa-glx` dependency.

6. **Fix Broken Dependencies (if needed)**  
   Automatically runs `apt --fix-broken install` if the installation fails.

7. **Cleanup**  
   Runs `apt autoremove` to remove unused packages.

---

## Usage Instructions

1. **Place the Packet Tracer `.deb` file in your Music directory**

   Example path:
   ```bash
   ~/Music/Packet_Tracer822_amd64_signed.deb
````

2. **Make the script executable**

   ```bash
   chmod +x install_packet_tracer.sh
   ```

3. **Run the script**

   ```bash
   ./install_packet_tracer.sh
   ```

4. **Launch Packet Tracer**

   * From application menu
   * Or run from terminal:

     ```bash
     packettracer
     ```

---

## Notes

* The script uses `dpkg --ignore-depends=libgl1-mesa-glx` to work around a known issue with newer Ubuntu versions.
* If the installation fails due to dependencies, the script automatically attempts to fix them.
* The `.deb` file must be downloaded from the official Cisco NetAcad portal before running the script.

---

## Example Terminal Output

```
Starting Packet Tracer installation...
Updating package lists...
Installing dependencies: dialog, libgl1, libxcb-xinerama0, ...
Removing existing or broken Packet Tracer package...
Installing Packet Tracer (ignoring deprecated libgl1-mesa-glx)...
Cleaning up unused packages...
Installation complete! Launch Packet Tracer from the application menu or by typing: packettracer
```

---

## Troubleshooting

| Issue                                | Solution                                                              |
| ------------------------------------ | --------------------------------------------------------------------- |
| `.deb` file not found                | Make sure it's located at `~/Music/Packet_Tracer822_amd64_signed.deb` |
| `dpkg` error about missing libraries | Script auto-runs `apt --fix-broken install` to resolve it             |
| Packet Tracer doesn't launch         | Try running `packettracer` in terminal and check error output         |


---

### Author

**Subash Subedi**
Cisco Packet Tracer Installer Script — 2025
GitHub: [whosubashsubedii](https://github.com/whosubashsubedii)

---
