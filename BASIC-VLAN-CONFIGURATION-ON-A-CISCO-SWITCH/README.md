
# Switch Configuration README

This document outlines the configuration steps for a Cisco switch, including setting the hostname, configuring the system clock, creating VLANs, and assigning interfaces to specific VLANs. The configuration is performed using Cisco IOS commands in the command-line interface (CLI).

## Table of Contents
1. [Overview](#overview)  
2. [Prerequisites](#prerequisites)  
3. [Configuration Steps](#configuration-steps)  
   - [Step 1: Set Hostname and System Clock](#step-1-set-hostname-and-system-clock)  
   - [Step 2: Create VLANs](#step-2-create-vlans)  
   - [Step 3: Verify VLAN Creation](#step-3-verify-vlan-creation)  
   - [Step 4: Assign Interfaces to VLANs](#step-4-assign-interfaces-to-vlans)  
4. [Saving the Configuration](#saving-the-configuration)  
5. [Verification](#verification)  
6. [Notes](#notes)  
7. [Author](#author)  
8. [License](#license)  

## Overview
This project configures a Cisco switch with the hostname "KTM," sets the system clock, creates four VLANs (Marketing, Accounting, Sales, and Administrator), and assigns specific FastEthernet interfaces to these VLANs. The configuration ensures that devices connected to these interfaces are segmented into their respective VLANs for network organization and security.

## Prerequisites
- A Cisco switch running Cisco IOS.  
- Access to the switch via console or SSH with administrative privileges.  
- Basic understanding of Cisco IOS commands and VLAN configuration.

## Configuration Steps

### Step 1: Set Hostname and System Clock
The switch's hostname is set to "KTM," and the system clock is configured to reflect the correct time and date.

```plaintext
Switch>enable
Switch#configure terminal
Switch(config)#hostname KTM
KTM(config)#clock set 09:15:30 november 20 2023
KTM#show clock
9:15:35.873 UTC Mon Nov 20 2023
KTM#write
Building configuration...
[OK]
KTM#
````

* `hostname KTM`: Sets the switch hostname to "KTM."
* `clock set 09:15:30 november 20 2023`: Sets the system clock to 09:15:30 on November 20, 2023.
* `show clock`: Verifies the configured time.
* `write`: Saves the configuration to non-volatile memory.

### Step 2: Create VLANs

Four VLANs are created and named for different departments: Marketing (VLAN 10), Accounting (VLAN 20), Sales (VLAN 30), and Administrator (VLAN 40).

```plaintext
KTM>enable
KTM#configure terminal
KTM(config)#vlan 10
KTM(config-vlan)#name Marketing
KTM(config-vlan)#vlan 20
KTM(config-vlan)#name Accounting
KTM(config-vlan)#vlan 30
KTM(config-vlan)#name Sales
KTM(config-vlan)#vlan 40
KTM(config-vlan)#name Administrator
KTM#write
Building configuration...
[OK]
KTM#
```

* `vlan <number>`: Creates a VLAN with the specified ID.
* `name <vlan-name>`: Assigns a descriptive name to the VLAN.
* `write`: Saves the VLAN configuration.

### Step 3: Verify VLAN Creation

To confirm that the VLANs were created successfully, use the `do show vlan` command from configuration mode.

```plaintext
KTM(config)#do show vlan
```

This command displays the VLAN database, including VLAN IDs and their associated names. Ensure that VLANs 10, 20, 30, and 40 are listed with their respective names.

### Step 4: Assign Interfaces to VLANs

FastEthernet interfaces are configured as access ports and assigned to the appropriate VLANs. By default, all interfaces are in VLAN 1 (the default VLAN). This step moves them to their respective VLANs.

```plaintext
KTM>enable
KTM#configure terminal
KTM(config)#interface fastEthernet 0/1
KTM(config-if)#switchport mode access
KTM(config-if)#switchport access vlan 10
KTM(config-if)#exit
KTM(config)#interface fastEthernet 0/2
KTM(config-if)#switchport mode access
KTM(config-if)#switchport access vlan 20
KTM(config-if)#exit
KTM(config)#interface fastEthernet 0/3
KTM(config-if)#switchport mode access
KTM(config-if)#switchport access vlan 30
KTM(config-if)#exit
KTM(config)#interface fastEthernet 0/4
KTM(config-if)#switchport mode access
KTM(config-if)#switchport access vlan 40
KTM(config-if)#exit
KTM(config)#interface fastEthernet 0/5
KTM(config-if)#switchport mode access
KTM(config-if)#switchport access vlan 10
KTM(config-if)#exit
KTM(config)#interface fastEthernet 0/6
KTM(config-if)#switchport mode access
KTM(config-if)#switchport access vlan 20
KTM(config-if)#exit
KTM(config)#interface fastEthernet 0/7
KTM(config-if)#switchport mode access
KTM(config-if)#switchport access vlan 30
KTM(config-if)#exit
KTM(config)#interface fastEthernet 0/8
KTM(config-if)#switchport mode access
KTM(config-if)#switchport access vlan 40
KTM(config-if)#exit
KTM(config)#write
```

* `interface fastEthernet <port>`: Enters interface configuration mode for the specified port.
* `switchport mode access`: Configures the interface as an access port.
* `switchport access vlan <number>`: Assigns the interface to the specified VLAN.
* `write`: Saves the interface configuration.

**Interface Assignments:**

* FastEthernet 0/1 and 0/5: VLAN 10 (Marketing)
* FastEthernet 0/2 and 0/6: VLAN 20 (Accounting)
* FastEthernet 0/3 and 0/7: VLAN 30 (Sales)
* FastEthernet 0/4 and 0/8: VLAN 40 (Administrator)

## Saving the Configuration

The `write` command (or `wr` shorthand) is used after each configuration step to save changes to the startup configuration, ensuring they persist after a reboot.

## Verification

To verify the configuration:

* Use `show vlan brief` to confirm VLAN creation and interface assignments.
* Use `show running-config` to view the full configuration, including hostname, VLANs, and interface settings.
* Use `show clock` to verify the system time.

Example:

```plaintext
KTM#show vlan brief
KTM#show running-config
KTM#show clock
```

## Notes

* Ensure the switch has sufficient resources to support the configured VLANs and interfaces.
* If an interface is not assigned to the desired VLAN after configuration, double-check the `switchport mode access` and `switchport access vlan` commands.
* The `do` command allows execution of privileged commands from configuration mode.
* For production environments, consider additional configurations such as port security, spanning tree protocol, or inter-VLAN routing.
* This configuration assumes FastEthernet interfaces; adjust interface types (e.g., GigabitEthernet) according to your switch model.

## Author

Prepared by Subash Subedi.


```

---

If you want me to replace `Subash Subedi` with your actual name or GitHub handle, just let me know! Otherwise, you’re good to go. Would you like a sample MIT LICENSE file too?
```
