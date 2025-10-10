# Trading Floor Network Design README

This document outlines the configuration steps for designing and implementing a network for a trading floor support center moving to a new building. The network is designed using Cisco Packet Tracer, adhering to a hierarchical model with redundancy, VLAN segmentation, and connectivity to two Internet Service Providers (ISPs). The configuration supports 600 users across three floors, with each department in a separate VLAN and subnetwork, dynamic IP allocation via DHCP, and static IP addressing for servers.

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Network Design](#network-design)
4. [Configuration Steps](#configuration-steps)
   - [Step 1: Basic Device Settings and SSH Configuration](#step-1-basic-device-settings-and-ssh-configuration)
   - [Step 2: VLAN Creation and Port Assignment](#step-2-vlan-creation-and-port-assignment)
   - [Step 3: Subnetting and IP Addressing](#step-3-subnetting-and-ip-addressing)
   - [Step 4: Inter-VLAN Routing](#step-4-inter-vlan-routing)
   - [Step 5: DHCP Configuration](#step-5-dhcp-configuration)
   - [Step 6: OSPF Routing Protocol](#step-6-ospf-routing-protocol)
   - [Step 7: Port Security for Finance and Accounts Department](#step-7-port-security-for-finance-and-accounts-department)
   - [Step 8: NAT/PAT Configuration](#step-8-natpat-configuration)
   - [Step 9: Access Control Lists (ACLs)](#step-9-access-control-lists-acls)
   - [Step 10: Wireless Network Configuration](#step-10-wireless-network-configuration)
5. [Verification](#verification)
6. [Notes](#notes)

## Overview
The trading floor support center requires a new network to support 600 staff across three floors, with two departments per floor (120 users each) and a server room with 12 devices. The network uses a hierarchical design with redundancy at every layer, including two core routers and two multilayer switches. Each department is assigned a unique VLAN and subnetwork, with devices receiving IP addresses dynamically from DHCP servers in the server room, except for servers, which use static IPs. The network connects to two ISPs for redundancy, uses OSPF for routing, and implements port security, NAT/PAT, and ACLs for security and connectivity.

## Prerequisites
- Cisco Packet Tracer for network design and simulation.
- Cisco IOS-based routers and multilayer switches.
- Administrative access to all network devices.
- Knowledge of Cisco IOS commands, VLANs, OSPF, DHCP, NAT, ACLs, and wireless configuration.
- Physical or simulated cabling (e.g., serial cables for ISP connections, Ethernet for internal links).

## Network Design
The network follows a hierarchical model with three layers:
- **Core Layer**: Two core routers (CORE-Router1, CORE-Router2) connect to two ISPs and multilayer switches, providing redundancy and external connectivity.
- **Distribution Layer**: Two multilayer switches (Multilayer_1-Switch, Multilayer_2-Switch) handle inter-VLAN routing and connect to department switches.
- **Access Layer**: Department switches (one per department) and wireless access points provide connectivity for end devices.

**VLANs and Departments**:
- VLAN 10: Sales & Marketing (1st Floor, 120 users)
- VLAN 20: HR & Logistics (1st Floor, 120 users)
- VLAN 30: Finance & Accounts (2nd Floor, 120 users)
- VLAN 40: Administrator & Public Relations (2nd Floor, 120 users)
- VLAN 50: ICT (3rd Floor, 120 users)
- VLAN 60: Server Room (3rd Floor, 12 devices)

**IP Addressing**:
- Base network: 172.16.1.0/24
- Subnetted for each department and inter-device links.
- Public IPs for ISP connections: 195.136.17.0/30, 195.136.17.4/30, 195.136.17.8/30, 195.136.17.12/30.

## Configuration Steps

### Step 1: Basic Device Settings and SSH Configuration
Configure hostnames, console and enable passwords, banner messages, and disable IP domain lookup on all routers and switches. Enable SSH for secure remote access.

**Example for CORE-Router1**:
```plaintext
Router(config)#hostname CORE-Router1
CORE-Router1(config)#banner motd $No Authorized Access$
CORE-Router1(config)#no ip domain lookup
CORE-Router1(config)#line console 0
CORE-Router1(config-line)#password cisco
CORE-Router1(config-line)#login
CORE-Router1(config-line)#exit
CORE-Router1(config)#enable password cisco
CORE-Router1(config)#service password-encryption
CORE-Router1(config)#ip domain name cisco.net
CORE-Router1(config)#username admin password cisco
CORE-Router1(config)#crypto key generate rsa
CORE-Router1(config)#line vty 0 15
CORE-Router1(config-line)#login local
CORE-Router1(config-line)#transport input ssh
CORE-Router1(config-line)#exit
CORE-Router1(config)#ip ssh version 2
CORE-Router1(config)#do wr
```

Repeat similar configurations for CORE-Router2, Multilayer_1-Switch, Multilayer_2-Switch, and all department switches (Sales_and_Marketing_Department_Switch, Human_Resource_and_Logistics_Department_Switch, Finance_and_Account_Department_Switch, Administrator_and_Public_Relations_Department_Switch, ICT_Switch, Server_Room_Switch).

### Step 2: VLAN Creation and Port Assignment
Create VLANs on multilayer and department switches, and assign access ports to the appropriate VLANs. Configure trunk ports for inter-switch and switch-router connectivity.

**Example for Multilayer_1-Switch**:
```plaintext
Multilayer_1-Switch(config)#vlan 10
Multilayer_1-Switch(config-vlan)#name Sales&Marketing
Multilayer_1-Switch(config-vlan)#vlan 20
Multilayer_1-Switch(config-vlan)#name HR&Logistic
Multilayer_1-Switch(config-vlan)#vlan 30
Multilayer_1-Switch(config-vlan)#name Finance&Account
Multilayer_1-Switch(config-vlan)#vlan 40
Multilayer_1-Switch(config-vlan)#name Administrator&Public
Multilayer_1-Switch(config-vlan)#vlan 50
Multilayer_1-Switch(config-vlan)#name ICT
Multilayer_1-Switch(config-vlan)#vlan 60
Multilayer_1-Switch(config-vlan)#name SERVER
Multilayer_1-Switch(config-vlan)#exit
Multilayer_1-Switch(config)#interface range gigabitEthernet 1/0/3-8
Multilayer_1-Switch(config-if-range)#switchport mode trunk
Multilayer_1-Switch(config-if-range)#exit
Multilayer_1-Switch(config)#do wr
```

**Example for Sales_and_Marketing_Department_Switch**:
```plaintext
Sales_and_Marketing_Department_Switch(config)#vlan 10
Sales_and_Marketing_Department_Switch(config-vlan)#name Sales&Marketing
Sales_and_Marketing_Department_Switch(config-vlan)#exit
Sales_and_Marketing_Department_Switch(config)#interface range fastEthernet 0/1-24
Sales_and_Marketing_Department_Switch(config-if-range)#switchport mode access
Sales_and_Marketing_Department_Switch(config-if-range)#switchport access vlan 10
Sales_and_Marketing_Department_Switch(config-if-range)#exit
Sales_and_Marketing_Department_Switch(config)#interface range gigabitEthernet 0/1-2
Sales_and_Marketing_Department_Switch(config-if-range)#switchport mode trunk
Sales_and_Marketing_Department_Switch(config-if-range)#exit
Sales_and_Marketing_Department_Switch(config)#do wr
```

Repeat VLAN and port configurations for other department switches, assigning FastEthernet 0/1-24 to their respective VLANs (20, 30, 40, 50, 60) and configuring GigabitEthernet ports as trunks.

### Step 3: Subnetting and IP Addressing
Subnet the base network 172.16.1.0/24 to accommodate each department and inter-device links. Assign static IPs to servers and router/switch interfaces, and configure DHCP for dynamic allocation.

**Subnetting Plan**:
- **Sales & Marketing (VLAN 10)**: 172.16.1.0/25 (172.16.1.1–172.16.1.126, Broadcast: 172.16.1.127)
- **HR & Logistics (VLAN 20)**: 172.16.1.128/25 (172.16.1.129–172.16.1.254, Broadcast: 172.16.1.255)
- **Finance & Accounts (VLAN 30)**: 172.16.2.0/25 (172.16.2.1–172.16.2.126, Broadcast: 172.16.2.127)
- **Administrator & Public Relations (VLAN 40)**: 172.16.2.128/25 (172.16.2.129–172.16.2.254, Broadcast: 172.16.2.255)
- **ICT (VLAN 50)**: 172.16.3.0/25 (172.16.3.1–172.16.3.126, Broadcast: 172.16.3.127)
- **Server Room (VLAN 60)**: 172.16.3.128/25 (172.16.3.129–172.16.3.254, Broadcast: 172.16.3.255)
- **Router to Multilayer Switch Links**:
  - R1–MLSW1: 172.16.3.144/30 (172.16.3.145–172.16.3.146)
  - R1–MLSW2: 172.16.3.148/30 (172.16.3.149–172.16.3.150)
  - R2–MLSW1: 172.16.3.152/30 (172.16.3.153–172.16.3.154)
  - R2–MLSW2: 172.16.3.156/30 (172.16.3.157–172.16.3.158)
- **ISP Links**:
  - R1–ISP1: 195.136.17.0/30
  - R1–ISP2: 195.136.17.4/30
  - R2–ISP1: 195.136.17.8/30
  - R2–ISP2: 195.136.17.12/30

**Example for CORE-Router1**:
```plaintext
CORE-Router1(config)#interface GigabitEthernet0/0
CORE-Router1(config-if)#ip address 172.16.3.146 255.255.255.252
CORE-Router1(config-if)#no shutdown
CORE-Router1(config-if)#exit
CORE-Router1(config)#interface GigabitEthernet0/1
CORE-Router1(config-if)#ip address 172.16.3.154 255.255.255.252
CORE-Router1(config-if)#no shutdown
CORE-Router1(config-if)#exit
CORE-Router1(config)#interface Serial0/0/0
CORE-Router1(config-if)#ip address 195.136.17.1 255.255.255.252
CORE-Router1(config-if)#no shutdown
CORE-Router1(config-if)#exit
CORE-Router1(config)#interface Serial0/0/1
CORE-Router1(config-if)#ip address 195.136.17.5 255.255.255.252
CORE-Router1(config-if)#no shutdown
CORE-Router1(config-if)#exit
CORE-Router1(config)#do wr
```

**Example for Multilayer_1-Switch**:
```plaintext
Multilayer_1-Switch(config)#interface GigabitEthernet1/0/1
Multilayer_1-Switch(config-if)#no switchport
Multilayer_1-Switch(config-if)#ip address 172.16.3.145 255.255.255.252
Multilayer_1-Switch(config-if)#no shutdown
Multilayer_1-Switch(config-if)#exit
Multilayer_1-Switch(config)#interface GigabitEthernet1/0/2
Multilayer_1-Switch(config-if)#no switchport
Multilayer_1-Switch(config-if)#ip address 172.16.3.149 255.255.255.252
Multilayer_1-Switch(config-if)#no shutdown
Multilayer_1-Switch(config-if)#exit
Multilayer_1-Switch(config)#do wr
```

Assign static IPs to servers in VLAN 60 (e.g., 172.16.3.130 for DHCP server).

### Step 4: Inter-VLAN Routing
Configure Switch Virtual Interfaces (SVIs) on multilayer switches to enable inter-VLAN routing. Use `ip helper-address` to forward DHCP requests to the DHCP server.

**Example for Multilayer_1-Switch**:
```plaintext
Multilayer_1-Switch(config)#interface vlan 10
Multilayer_1-Switch(config-if)#ip address 172.16.1.1 255.255.255.128
Multilayer_1-Switch(config-if)#ip helper-address 172.16.3.130
Multilayer_1-Switch(config-if)#no shutdown
Multilayer_1-Switch(config-if)#exit
Multilayer_1-Switch(config)#interface vlan 20
Multilayer_1-Switch(config-if)#ip address 172.16.1.129 255.255.255.128
Multilayer_1-Switch(config-if)#ip helper-address 172.16.3.130
Multilayer_1-Switch(config-if)#no shutdown
Multilayer_1-Switch(config-if)#exit
Multilayer_1-Switch(config)#interface vlan 30
Multilayer_1-Switch(config-if)#ip address 172.16.2.1 255.255.255.128
Multilayer_1-Switch(config-if)#ip helper-address 172.16.3.130
Multilayer_1-Switch(config-if)#no shutdown
Multilayer_1-Switch(config-if)#exit
Multilayer_1-Switch(config)#interface vlan 40
Multilayer_1-Switch(config-if)#ip address 172.16.2.129 255.255.255.128
Multilayer_1-Switch(config-if)#ip helper-address 172.16.3.130
Multilayer_1-Switch(config-if)#no shutdown
Multilayer_1-Switch(config-if)#exit
Multilayer_1-Switch(config)#interface vlan 50
Multilayer_1-Switch(config-if)#ip address 172.16.3.1 255.255.255.128
Multilayer_1-Switch(config-if)#ip helper-address 172.16.3.130
Multilayer_1-Switch(config-if)#no shutdown
Multilayer_1-Switch(config-if)#exit
Multilayer_1-Switch(config)#interface vlan 60
Multilayer_1-Switch(config-if)#ip address 172.16.3.129 255.255.255.240
Multilayer_1-Switch(config-if)#no shutdown
Multilayer_1-Switch(config-if)#exit
Multilayer_1-Switch(config)#do wr
```

Repeat for Multilayer_2-Switch with identical SVI configurations.

### Step 5: DHCP Configuration
Configure a DHCP server in the server room (VLAN 60, e.g., IP 172.16.3.130) to allocate IPs dynamically for all departments except servers.

**Example DHCP Server Configuration**:
```plaintext
DHCP-Server(config)#ip dhcp pool SALES_MARKETING
DHCP-Server(dhcp-config)#network 172.16.1.0 255.255.255.128
DHCP-Server(dhcp-config)#default-router 172.16.1.1
DHCP-Server(dhcp-config)#exit
DHCP-Server(config)#ip dhcp pool HR_LOGISTICS
DHCP-Server(dhcp-config)#network 172.16.1.128 255.255.255.128
DHCP-Server(dhcp-config)#default-router 172.16.1.129
DHCP-Server(dhcp-config)#exit
DHCP-Server(config)#ip dhcp pool FINANCE_ACCOUNTS
DHCP-Server(dhcp-config)#network 172.16.2.0 255.255.255.128
DHCP-Server(dhcp-config)#default-router 172.16.2.1
DHCP-Server(dhcp-config)#exit
DHCP-Server(config)#ip dhcp pool ADMIN_PUBLIC
DHCP-Server(dhcp-config)#network 172.16.2.128 255.255.255.128
DHCP-Server(dhcp-config)#default-router 172.16.2.129
DHCP-Server(dhcp-config)#exit
DHCP-Server(config)#ip dhcp pool ICT
DHCP-Server(dhcp-config)#network 172.16.3.0 255.255.255.128
DHCP-Server(dhcp-config)#default-router 172.16.3.1
DHCP-Server(dhcp-config)#exit
DHCP-Server(config)#interface GigabitEthernet0/0
DHCP-Server(config-if)#ip address 172.16.3.130 255.255.255.240
DHCP-Server(config-if)#no shutdown
DHCP-Server(config-if)#exit
DHCP-Server(config)#do wr
```

### Step 6: OSPF Routing Protocol
Configure OSPF on core routers and multilayer switches to advertise internal and external routes.

**Example for CORE-Router1**:
```plaintext
CORE-Router1(config)#router ospf 10
CORE-Router1(config-router)#router-id 3.3.3.3
CORE-Router1(config-router)#network 195.136.17.0 0.0.0.3 area 0
CORE-Router1(config-router)#network 195.136.17.4 0.0.0.3 area 0
CORE-Router1(config-router)#network 172.16.3.144 0.0.0.3 area 0
CORE-Router1(config-router)#network 172.16.3.152 0.0.0.3 area 0
CORE-Router1(config-router)#exit
CORE-Router1(config)#do wr
```

**Example for Multilayer_1-Switch**:
```plaintext
Multilayer_1-Switch(config)#router ospf 10
Multilayer_1-Switch(config-router)#router-id 1.1.1.1
Multilayer_1-Switch(config-router)#network 172.16.1.0 0.0.0.127 area 0
Multilayer_1-Switch(config-router)#network 172.16.1.128 0.0.0.127 area 0
Multilayer_1-Switch(config-router)#network 172.16.2.0 0.0.0.127 area 0
Multilayer_1-Switch(config-router)#network 172.16.2.128 0.0.0.127 area 0
Multilayer_1-Switch(config-router)#network 172.16.3.0 0.0.0.127 area 0
Multilayer_1-Switch(config-router)#network 172.16.3.128 0.0.0.15 area 0
Multilayer_1-Switch(config-router)#network 172.16.3.144 0.0.0.3 area 0
Multilayer_1-Switch(config-router)#network 172.16.3.152 0.0.0.3 area 0
Multilayer_1-Switch(config-router)#exit
Multilayer_1-Switch(config)#do wr
```

Repeat for CORE-Router2 (router-id 4.4.4.4) and Multilayer_2-Switch (router-id 2.2.2.2), adjusting network statements accordingly.

### Step 7: Port Security for Finance and Accounts Department
Configure port security on the Finance_and_Account_Department_Switch to allow only one device per port, using sticky MAC address learning and shutdown violation mode.

**Example**:
```plaintext
Finance_and_Account_Department_Switch(config)#interface range fastEthernet 0/1-24
Finance_and_Account_Department_Switch(config-if-range)#switchport mode access
Finance_and_Account_Department_Switch(config-if-range)#switchport access vlan 30
Finance_and_Account_Department_Switch(config-if-range)#switchport port-security
Finance_and_Account_Department_Switch(config-if-range)#switchport port-security maximum 1
Finance_and_Account_Department_Switch(config-if-range)#switchport port-security mac-address sticky
Finance_and_Account_Department_Switch(config-if-range)#switchport port-security violation shutdown
Finance_and_Account_Department_Switch(config-if-range)#exit
Finance_and_Account_Department_Switch(config)#do wr
```

### Step 8: NAT/PAT Configuration
Configure PAT on core routers to translate internal private IPs to public IPs for Internet access, using the outbound interface IP addresses.

**Example for CORE-Router1**:
```plaintext
CORE-Router1(config)#ip nat inside source list 1 interface Serial0/0/0 overload
CORE-Router1(config)#ip nat inside source list 1 interface Serial0/0/1 overload
CORE-Router1(config)#access-list 1 permit 172.16.1.0 0.0.0.127
CORE-Router1(config)#access-list 1 permit 172.16.1.128 0.0.0.127
CORE-Router1(config)#access-list 1 permit 172.16.2.0 0.0.0.127
CORE-Router1(config)#access-list 1 permit 172.16.2.128 0.0.0.127
CORE-Router1(config)#access-list 1 permit 172.16.3.0 0.0.0.127
CORE-Router1(config)#access-list 1 permit 172.16.3.128 0.0.0.15
CORE-Router1(config)#interface range gigabitEthernet 0/0-1
CORE-Router1(config-if-range)#ip nat inside
CORE-Router1(config-if-range)#exit
CORE-Router1(config)#interface Serial0/0/0
CORE-Router1(config-if)#ip nat outside
CORE-Router1(config-if)#exit
CORE-Router1(config)#interface Serial0/0/1
CORE-Router1(config-if)#ip nat outside
CORE-Router1(config-if)#exit
CORE-Router1(config)#do wr
```

Repeat for CORE-Router2 with appropriate interfaces.

### Step 9: Access Control Lists (ACLs)
The ACLs for PAT (access-list 1) permit traffic from all internal subnets. Additional ACLs can be configured for specific security policies if required.

### Step 10: Wireless Network Configuration
Configure wireless access points (APs) in each department to provide wireless connectivity, assigning them to the respective VLANs.

**Example for Sales & Marketing AP**:
```plaintext
AP-Sales-Marketing(config)#interface Dot11Radio0
AP-Sales-Marketing(config-if)#ssid SalesMarketingWiFi
AP-Sales-Marketing(config-if-ssid)#vlan 10
AP-Sales-Marketing(config-if-ssid)#authentication open
AP-Sales-Marketing(config-if-ssid)#exit
AP-Sales-Marketing(config-if)#no shutdown
AP-Sales-Marketing(config-if)#exit
AP-Sales-Marketing(config)#interface GigabitEthernet0
AP-Sales-Marketing(config-if)#switchport mode trunk
AP-Sales-Marketing(config-if)#no shutdown
AP-Sales-Marketing(config-if)#exit
AP-Sales-Marketing(config)#do wr
```

Repeat for other departments, assigning APs to VLANs 20, 30, 40, 50, and ensuring trunk connectivity to department switches.

## Verification
To ensure the configuration is correct:
- **VLANs**: Use `show vlan brief` on switches to verify VLANs and port assignments.
- **IP Addressing**: Use `show ip interface brief` to confirm IP assignments on routers and switches.
- **DHCP**: Use `show ip dhcp binding` on the DHCP server to verify IP allocations.
- **OSPF**: Use `show ip ospf neighbor` and `show ip route` to confirm routing table and neighbor adjacency.
- **Port Security**: Use `show port-security` on the Finance_and_Account_Department_Switch to verify MAC address bindings.
- **NAT/PAT**: Use `show ip nat translations` to verify address translations.
- **Connectivity**: Ping between devices across VLANs and to external networks via ISPs.
- **Wireless**: Connect a wireless client to each AP and verify IP assignment and connectivity.

## Notes
- Ensure correct cabling in Cisco Packet Tracer (e.g., serial cables for ISP links, Ethernet for internal connections).
- The DHCP server’s IP (172.16.3.130) is static and must be excluded from the DHCP pool.
- Adjust OSPF network statements if additional subnets are added.
- For production, consider advanced security features like WPA2 for wireless, additional ACLs, and redundancy protocols (e.g., HSRP).
- Save configurations frequently using `write` to prevent loss of settings.
- Test redundancy by simulating failures (e.g., shutting down one router or ISP link) to ensure failover.

