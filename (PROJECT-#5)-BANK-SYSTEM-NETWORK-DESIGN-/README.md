# Bank System Network Design README

This document details the design and implementation of a network for Radeon Company Ltd., a US-owned banking and insurance company establishing its first African branch in a four-story building in Nairobi, Kenya. The network supports approximately 60 users per department (wired and wireless), with departments segmented by VLANs and subnetworks. The design follows a hierarchical model with redundancy elements, using Cisco Packet Tracer for simulation. Key features include OSPF routing, DHCP for dynamic IP assignment, SSH for remote access, port security, and inter-VLAN routing via multilayer switches.

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Network Topology](#network-topology)
4. [Configuration Steps](#configuration-steps)
   - [Step 1: Basic Device Settings](#step-1-basic-device-settings)
   - [Step 2: VLAN Creation and Port Assignment](#step-2-vlan-creation-and-port-assignment)
   - [Step 3: Subnetting and IP Addressing](#step-3-subnetting-and-ip-addressing)
   - [Step 4: Link Aggregation (EtherChannel with LACP)](#step-4-link-aggregation-etherchannel-with-lacp)
   - [Step 5: Inter-VLAN Routing](#step-5-inter-vlan-routing)
   - [Step 6: DHCP Configuration](#step-6-dhcp-configuration)
   - [Step 7: SSH Configuration for Secure Remote Access](#step-7-ssh-configuration-for-secure-remote-access)
   - [Step 8: OSPF Routing Protocol](#step-8-ospf-routing-protocol)
   - [Step 9: Port Security](#step-9-port-security)
   - [Step 10: Host Device Configurations](#step-10-host-device-configurations)
   - [Step 11: Testing and Verification](#step-11-testing-and-verification)
5. [Notes](#notes)

## Overview
The network is designed for a four-story building with the following departments:
- **1st Floor**: Management (VLAN 10), Research (VLAN 20), Human Resource (VLAN 30)
- **2nd Floor**: Marketing (VLAN 40), Account (VLAN 50), Finance (VLAN 60)
- **3rd Floor**: Logistics (VLAN 70), Customer (VLAN 80), Guest (VLAN 90)
- **4th Floor**: Admin (VLAN 100), ICT (VLAN 110), Server (VLAN 120)

The topology uses a mesh for core connectivity among routers, with multilayer (L3) switches handling inter-VLAN routing for floor pairs (1st/2nd and 3rd/4th). Layer 2 switches connect end devices in each department. Wireless access is provided per department (though specific AP configurations are not detailed here). Servers include HTTP, email, and DHCP in the server room. All end devices use dynamic IP assignment via DHCP, except servers which are static.

## Prerequisites
- Cisco Packet Tracer or GNS3 for simulation.
- Modeling tools like Draw.io, MS Visio, or Visual Paradigm for topology diagrams.
- Cisco IOS devices: ISR 4331 routers, 3650-24P L3 switches, 2960-24TT L2 switches.
- Basic knowledge of Cisco IOS commands, VLANs, OSPF, DHCP, SSH, EtherChannel, and port security.

## Network Topology
The network employs a hierarchical design:
- **Core Layer**: Four routers (one per floor) connected in a mesh via GigabitEthernet and serial links for redundancy.
- **Distribution Layer**: Four L3 switches (one per floor, grouped for 1st/2nd and 3rd/4th in configurations) for inter-VLAN routing and aggregation.
- **Access Layer**: L2 switches per department, connected to L3 switches via EtherChannel trunks.

Cabling:
- Copper straight-through for LAN connections.
- Serial DCE for router interconnections.

Devices are connected with appropriate cabling to ensure redundancy and high availability.

## Configuration Steps

### Step 1: Basic Device Settings
Configure hostnames, clock, banners, usernames with privileges, password encryption, console login, and disable IP domain lookup on all switches and routers.

**Example for Management Department Switch**:
```plaintext
enable
configure terminal
hostname MANAGEMENT_SWITCH
do clock set 09:17:00 29 APRIL 2025
banner motd $ ONLY AUTHORIZED USER $
username admin privilege 1 secret admin
username cisco privilege 5 secret cisco
username subash privilege 15 secret subash
username SUBASH privilege 15 secret SUBASH
service password-encryption
line console 0
motd-banner
login local
exit
no ip domain lookup
do wr
end
exit
```

Repeat similar configurations for all other L2 switches (Logistics, Research, Customer, Human Resource, Guest, Marketing, Admin, Account, ICT, Finance, Server), L3 switches (1st-Floor-L3-Switch, 2nd-Floor-L3-Switch, 3rd-Floor-L3-Switch, 4th-Floor-L3-Switch), and routers (1st-Floor-Router, 2nd-Floor-Router, 3rd-Floor-Router, 4th-Floor-Router).

### Step 2: VLAN Creation and Port Assignment
Create VLANs on L2 and L3 switches, assign access ports on L2 switches to department VLANs, and configure default gateways. Use VLAN 999 as native for trunks.

**Example for Management Department Switch**:
```plaintext
enable
configure terminal
vlan 10
name MANAGEMENT-1st-Floor
exit
vlan 999
name NATIVE
exit
interface vlan 10
ip address 192.168.1.254 255.255.255.0
no shutdown
exit
ip default-gateway 192.168.1.1
interface range fastethernet 0/1-24
switchport mode access
switchport access vlan 10
no shutdown
exit
end
wr
```

Repeat for other L2 switches with their respective VLANs and names (e.g., VLAN 70 for Logistics, VLAN 20 for Research, etc.).

For L3 switches:
- 1st & 2nd Floor L3 Switch: Create VLANs 10, 20, 30, 40, 50, 60, 999.
- 3rd & 4th Floor L3 Switch: Create VLANs 70, 80, 90, 100, 110, 120, 999.

**Example for 1st & 2nd Floor L3 Switch**:
```plaintext
enable
configure terminal
vlan 10
name MANAGEMENT-1st-Floor
exit
vlan 20
name RESEARCH-1st-FLOOR
exit
vlan 30
name HUMAN-RESOURCE-1st-FLOOR
exit
vlan 40
name MARKETING-2ND-FLOOR
exit
vlan 50
name ACCOUNT-2ND-FLOOR
exit
vlan 60
name FINANCE-2ND-FLOOR
exit
vlan 999
name NATIVE
exit
end
wr
```

### Step 3: Subnetting and IP Addressing
Base address: 192.168.10.0 (though configurations use 192.168.1.0–12.0 for departments). Subnet each department into /24 networks.

**Subnetting Plan**:

| Floor     | Department             | Network ID     | Gateway       | Usable Range          | Broadcast     | Subnet Mask    |
|-----------|------------------------|----------------|---------------|-----------------------|---------------|----------------|
| 1st      | Management            | 192.168.1.0/24 | 192.168.1.1  | 192.168.1.2–253      | 192.168.1.255 | 255.255.255.0 |
| 1st      | Research              | 192.168.2.0/24 | 192.168.2.1  | 192.168.2.2–253      | 192.168.2.255 | 255.255.255.0 |
| 1st      | Human Resource        | 192.168.3.0/24 | 192.168.3.1  | 192.168.3.2–253      | 192.168.3.255 | 255.255.255.0 |
| 2nd      | Marketing             | 192.168.4.0/24 | 192.168.4.1  | 192.168.4.2–253      | 192.168.4.255 | 255.255.255.0 |
| 2nd      | Account               | 192.168.5.0/24 | 192.168.5.1  | 192.168.5.2–253      | 192.168.5.255 | 255.255.255.0 |
| 2nd      | Finance               | 192.168.6.0/24 | 192.168.6.1  | 192.168.6.2–253      | 192.168.6.255 | 255.255.255.0 |
| 3rd      | Logistics & Store     | 192.168.7.0/24 | 192.168.7.1  | 192.168.7.2–253      | 192.168.7.255 | 255.255.255.0 |
| 3rd      | Customer Care         | 192.168.8.0/24 | 192.168.8.1  | 192.168.8.2–253      | 192.168.8.255 | 255.255.255.0 |
| 3rd      | Guest                 | 192.168.9.0/24 | 192.168.9.1  | 192.168.9.2–253      | 192.168.9.255 | 255.255.255.0 |
| 4th      | Administration        | 192.168.10.0/24| 192.168.10.1| 192.168.10.2–253    | 192.168.10.255| 255.255.255.0 |
| 4th      | ICT                   | 192.168.11.0/24| 192.168.11.1| 192.168.11.2–253    | 192.168.11.255| 255.255.255.0 |
| 4th      | Server                | 192.168.12.0/24| 192.168.12.1| 192.168.12.2–253    | 192.168.12.255| 255.255.255.0 |

Inter-device links use 10.10.10.0/30 subnets.

**Example for 1st Floor L3 Switch Interfaces**:
```plaintext
enable
configure terminal
interface GigabitEthernet 1/1/1
no switchport
ip address 10.10.10.1 255.255.255.252
no shutdown
exit
interface GigabitEthernet 1/1/2
no switchport
ip address 10.10.10.9 255.255.255.252
no shutdown
exit
end
wr
```

Repeat for other L3 switches and routers with assigned IPs (e.g., serial links with clock rates on DCE sides).

### Step 4: Link Aggregation (EtherChannel with LACP)
Configure LACP EtherChannel for trunks between L2 department switches and L3 switches, allowing only department VLANs.

**Example for Management Department Switch**:
```plaintext
enable
configure terminal
interface GigabitEthernet 0/1
description ** TRUNK INTERFACE LACP ETHERCHANNEL FIRST FLOOR L3 SWITCH **
shutdown
channel-protocol lacp
channel-group 1 mode active
no shutdown
exit
interface port-channel 1
switchport mode trunk
switchport trunk native vlan 999
switchport trunk allowed vlan 10
switchport nonegotiate
exit
interface GigabitEthernet 0/2
description ** TRUNK INTERFACE LACP ETHERCHANNEL FIRST FLOOR L3 SWITCH **
shutdown
channel-protocol lacp
channel-group 2 mode active
no shutdown
exit
interface port-channel 2
switchport mode trunk
switchport trunk native vlan 999
switchport trunk allowed vlan 10
switchport nonegotiate
exit
do wr
```

Repeat for all L2 switches. On L3 switches, configure corresponding port-channels (e.g., group 1 for Management, group 7 for Logistics).

### Step 5: Inter-VLAN Routing
Enable SVIs on L3 switches for VLAN gateways, with ip helper-address for DHCP forwarding.

**Example for 1st & 2nd Floor L3 Switch**:
```plaintext
enable
configure terminal
interface vlan 10
no shutdown
ip address 192.168.1.1 255.255.255.0
ip helper-address 192.168.12.10
exit
interface vlan 20
no shutdown
ip address 192.168.2.1 255.255.255.0
ip helper-address 192.168.12.10
exit
interface vlan 30
no shutdown
ip address 192.168.3.1 255.255.255.0
ip helper-address 192.168.12.10
exit
interface vlan 40
no shutdown
ip address 192.168.4.1 255.255.255.0
ip helper-address 192.168.12.10
exit
interface vlan 50
no shutdown
ip address 192.168.5.1 255.255.255.0
ip helper-address 192.168.12.10
exit
interface vlan 60
no shutdown
ip address 192.168.6.1 255.255.255.0
ip helper-address 192.168.12.10
exit
```

Repeat for 3rd & 4th Floor L3 Switch with VLANs 70–120.

### Step 6: DHCP Configuration
Configure a dedicated DHCP server in the server room (VLAN 120, static IP 192.168.12.10) with pools for each subnet, excluding server IPs.

(Note: Specific CLI for DHCP server not provided; use Packet Tracer's server config GUI to create pools matching subnet plan, with default routers as VLAN gateways.)

### Step 7: SSH Configuration for Secure Remote Access
Enable SSH on all devices with domain names, RSA keys, version 2, and VTY lines.

**Example for Management Department Switch**:
```plaintext
enable
configure terminal
ip domain-name management.com
crypto key generate rsa
1024
ip ssh version 2
line vty 0 15
login local
transport input ssh
exit
ip ssh time-out 60
ip ssh authentication-retries 3
exit
wr
```

Repeat for all switches and routers with unique domain names (e.g., logistic.com, firstfloormultilayer.com).

### Step 8: OSPF Routing Protocol
Enable OSPF process 10 on L3 switches and routers, advertising department networks and inter-device links in area 0.

**Example for 1st Floor L3 Switch**:
```plaintext
enable
configure terminal
ip routing
router ospf 10
network 10.10.10.0 0.0.0.3 area 0
network 10.10.10.8 0.0.0.3 area 0
network 192.168.1.0 0.0.0.255 area 0
network 192.168.2.0 0.0.0.255 area 0
network 192.168.3.0 0.0.0.255 area 0
network 192.168.4.0 0.0.0.255 area 0
network 192.168.5.0 0.0.0.255 area 0
network 192.168.6.0 0.0.0.255 area 0
exit
do wr
```

Repeat for other L3 switches (adjusting networks) and routers (focusing on inter-links).

### Step 9: Port Security
Configure port security on access ports of L2 and L3 switches: maximum 1 MAC, sticky learning, shutdown on violation.

**Example for L2 Switches**:
```plaintext
enable
configure terminal
interface range fastEthernet 0/1-23, gigabitEthernet 0/1-2
switchport port-security
switchport port-security maximum 1
switchport port-security violation shutdown
switchport port-security mac-address sticky
exit
```

**For L3 Switches**:
```plaintext
enable
configure terminal
interface range gigabitEthernet 1/0/1-23
switchport port-security
switchport port-security maximum 1
switchport port-security violation shutdown
switchport port-security mac-address sticky
exit
```

### Step 10: Host Device Configurations
End devices (PCs, laptops) are set to DHCP for automatic IP assignment. Wireless APs per department are connected to L2 switches, assigned to department VLANs (configure SSIDs and security as needed in Packet Tracer).

Servers in VLAN 120:
- DHCP Server: 192.168.12.10
- HTTP Server: Static IP (e.g., 192.168.12.11)
- Email Server: Static IP (e.g., 192.168.12.12)

Configure services on servers via Packet Tracer GUI.

### Step 11: Testing and Verification
- **VLANs**: `show vlan brief` to confirm assignments.
- **IP Addressing/DHCP**: `show ip dhcp binding` on DHCP server; ping within VLANs.
- **Inter-VLAN**: Ping across departments.
- **OSPF**: `show ip ospf neighbor`, `show ip route`.
- **SSH**: Test remote login from a host.
- **Port Security**: `show port-security` to verify MAC bindings.
- **EtherChannel**: `show etherchannel summary`.
- **Overall Connectivity**: Ping servers from all departments; access HTTP/email services.

## Notes
- Wireless configurations assume standard AP setup; add WPA2 security in production.
- The base IP in requirements (192.168.10.0) differs from used subnets (192.168.1.0–12.0); adjust if needed.
- Mesh topology provides redundancy; test failover by shutting interfaces.
- Save configurations with `wr` after each step.
- For real deployment, add firewalls, NAT for Internet, and monitoring tools.
- Department names have minor inconsistencies (e.g., Accounting vs. Research/Account); configurations prioritize provided CLI.
