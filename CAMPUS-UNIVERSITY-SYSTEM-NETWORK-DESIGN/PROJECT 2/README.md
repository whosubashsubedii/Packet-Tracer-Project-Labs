
## Design and Implementation of a Campus/University System Network Design

This repository contains the configuration and documentation for a network designed for Albion University, a large institution with two campuses situated 20 miles apart. The project, implemented in Cisco Packet Tracer, supports four faculties (Health and Sciences, Business, Engineering/Computing, and Art/Design) across multiple buildings, ensuring secure, scalable, and efficient connectivity. The network incorporates VLANs, inter-VLAN routing, DHCP, RIPv2, SSH, and port security, with connectivity to an external cloud-hosted email server.

**Author**: Subash Subedi  
**Date**: 2025

## Project Overview
Albion University’s network is designed to meet the following requirements:
- **Main Campus**:
  - **Building A**: Administrative staff (Management, HR, Finance) and Faculty of Business. Devices use dynamic IP addressing via a router-based DHCP server, with VLANs for segmentation.
  - **Building B**: Faculties of Engineering/Computing and Art/Design.
  - **Building C**: Student labs and IT department, hosting the university web server and other servers.
- **Branch Campus**: Faculty of Health and Sciences, with staff and student labs on separate floors.
- Each department/faculty operates on a separate IP network with dedicated VLANs.
- Switches are configured with VLANs, port security, and Link Aggregation Control Protocol (LACP) EtherChannel.
- RIPv2 is used for internal routing, with static routing for the external email server.
- Devices in Building A and the Branch Campus use dynamic IP addressing from DHCP servers on routers.

## Technologies Implemented
1. **Network Topology**: Combination of Bus and Star topologies in Cisco Packet Tracer.
2. **Hierarchical Network Design**:
   - Routers: Cisco 2911
   - Layer 3 Switch: Cisco 3650-24PS
   - Layer 2 Switch: Cisco 2960-24T
   - Devices: Servers, PCs, laptops, printers
3. **Cabling**:
   - Copper Straight-Through
   - Copper Cross-Over
   - Serial DCE
4. **VLAN Configuration**: VLANs 10–100 for department/faculty segmentation, with VLAN 999 as the native VLAN.
5. **LACP EtherChannel**: Configured for high-bandwidth trunk links between switches.
6. **Subnetting and IP Addressing**:
   - Main Campus VLANs: 192.168.1.0/24 to 192.168.8.0/24
   - Branch Campus VLANs: 192.168.9.0/24 to 192.168.10.0/24
   - Router-to-Router: 10.10.10.0/30, 10.10.10.4/30, 10.10.10.8/30
   - Email Server to Cloud: 20.0.0.0/30
7. **Inter-VLAN Routing**: Router-on-a-Stick configuration on the Main Campus Router.
8. **DHCP**: Router-based DHCP servers for Building A and Branch Campus.
9. **RIPv2**: Routing protocol for internal network connectivity.
10. **SSH**: Secure remote access to switches with multiple user privilege levels.
11. **Port Security**: Configured to restrict switch ports to a single MAC address with sticky learning.

## Network Topology
### Main Campus
- **Building A**:
  - VLAN 10: Administrative Staff (192.168.1.0/24)
  - VLAN 20: HR Department (192.168.2.0/24)
  - VLAN 30: Finance Department (192.168.3.0/24)
  - VLAN 40: Faculty of Business (192.168.4.0/24)
- **Building B**:
  - VLAN 50: Faculty of Engineering/Computing (192.168.5.0/24)
  - VLAN 60: Faculty of Art/Design (192.168.6.0/24)
- **Building C**:
  - VLAN 70: Student Labs (192.168.7.0/24)
  - VLAN 80: IT Department (192.168.8.0/24)
- **Main Multilayer Switch**: Connects all Main Campus VLANs.

### Branch Campus
- VLAN 90: Staff Departments (192.168.9.0/24)
- VLAN 100: Student Labs (192.168.10.0/24)
- **Branch Multilayer Switch**: Connects Branch Campus VLANs.

### External
- Cloud-hosted email server (20.0.0.0/30) connected via static routing.

## Configuration Details
### 1. VLAN Configuration
Each department/faculty is assigned a unique VLAN with a native VLAN (999) for trunk links. Switches are configured with IP addresses and default gateways.

Example for Administrative Staff Switch:
```plaintext
enable
configure terminal
hostname ADMIN_SWITCH
vlan 10
 name ADMIN_DEPARTMENT
exit
vlan 999
 name NATIVE_VLAN
exit
interface vlan 10
 ip address 192.168.1.254 255.255.255.0
 no shutdown
exit
ip default-gateway 192.168.1.1
interface range fastEthernet 0/1-24
 switchport mode access
 switchport access vlan 10
 no shutdown
exit
do wr
```

### 2. LACP EtherChannel
EtherChannel is configured using LACP (802.3ad) for high-bandwidth trunk links between Layer 2 and Layer 3 switches. Ports are set to `active` mode for automatic negotiation.

Example for Administrative Staff Switch:
```plaintext
enable
configure terminal
interface range GigabitEthernet 0/1-2
 description ** THIS TRUNK INTERFACE IS A LACP ETHERCHANNEL **
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
do wr
```

### 3. Inter-VLAN Routing
Configured on the Main Multilayer Switch using Router-on-a-Stick:
```plaintext
interface gigabitEthernet 0/0/0.10
 encapsulation dot1Q 10
 ip address 192.168.1.1 255.255.255.0
exit
```
Similar configurations apply for VLANs 20–80 (Main Campus) and VLANs 90–100 (Branch Campus).

### 4. DHCP Configuration
The Main and Branch Campus Routers act as DHCP servers for their respective VLANs:
```plaintext
enable
configure terminal
service dhcp
ip dhcp pool Admin-pool
 network 192.168.1.0 255.255.255.0
 default-router 192.168.1.1
 dns-server 192.168.1.1
 domain-name admin.com
exit
```

### 5. RIPv2 Routing
RIPv2 is configured for internal routing with no auto-summary:
```plaintext
enable
configure terminal
router rip
 version 2
 no auto-summary
 network 10.10.10.0
 network 10.10.10.4
 network 192.168.1.0
 ...
exit
do wr
```

### 6. Static Routing
Static routes are configured for the external email server:
- Main Campus Router to Cloud Router: 10.10.10.8/30
- Cloud Router to Email Server: 20.0.0.0/30

### 7. SSH Configuration
Switches are configured for secure remote access with multiple user privilege levels:
```plaintext
enable
configure terminal
username admin privilege 1 secret admin
username cisco privilege 5 secret cisco
username subash privilege 15 secret subash
ip domain-name admin.com
crypto key generate rsa
 1024
ip ssh version 2
line vty 0 4
 login local
 transport input ssh
exit
ip ssh time-out 60
ip ssh authentication-retries 3
exit
do wr
```

### 8. Port Security
Port security is enabled to restrict switch ports to a single MAC address with sticky learning:
```plaintext
interface range fastEthernet 0/1-23, gigabitEthernet 0/1-2
 switchport port-security
 switchport port-security maximum 1
 switchport port-security violation shutdown
 switchport port-security mac-address sticky
exit
```

## Setup Instructions
1. **Open Cisco Packet Tracer**: Create a new project.
2. **Add Devices**:
   - Place Cisco 2911 routers for Main Campus, Branch Campus, and Cloud.
   - Add Cisco 3650-24PS (L3) and 2960-24T (L2) switches for each department/faculty.
   - Include PCs, laptops, servers, and printers as needed.
3. **Connect Devices**:
   - Copper Straight-Through: PC-to-switch, switch-to-router.
   - Copper Cross-Over: Switch-to-switch.
   - Serial DCE: Router-to-router (Main Campus to Branch Campus, Main Campus to Cloud).
4. **Configure VLANs**:
   - Assign VLANs (10–100) to switches and ports.
   - Set switch IP addresses and default gateways.
5. **Configure EtherChannel**: Set up LACP on trunk links between L2 and L3 switches.
6. **Configure Routers**:
   - Set up subinterfaces for inter-VLAN routing.
   - Configure DHCP pools for Building A and Branch Campus.
   - Enable RIPv2 and static routes for the email server.
7. **Enable SSH and Port Security**: Configure on all switches for secure access and port restriction.
8. **Test Connectivity**:
   - Use `ping` to verify inter-VLAN and inter-campus communication.
   - Confirm DHCP IP assignments.
   - Test SSH access and port security enforcement.
   - Verify connectivity to the external email server.

## Testing and Verification
- **Ping Tests**: Verify communication between devices across VLANs and campuses.
- **DHCP Verification**: Ensure devices in Building A and Branch Campus receive dynamic IPs.
- **RIPv2**: Check routing tables with `show ip route`.
- **EtherChannel**: Verify LACP status with `show etherchannel summary`.
- **SSH Access**: Test remote access using SSH clients.
- **Port Security**: Confirm ports shut down on violation with `show port-security`.
- **External Server Access**: Verify connectivity to the email server.

## Files
- `albion_university_network.pkt`: Cisco Packet Tracer file with the complete network topology and configurations.
- `configurations/`: Directory containing individual configuration files for routers and switches.

## Notes
- Ensure all devices are powered on in Packet Tracer before testing.
- Verify IP addressing and subnet masks to prevent conflicts.
- Save configurations using `do wr` to preserve settings.
- LACP requires active mode on at least one side of the link to form an EtherChannel.

## Author
Subash Subedi  
This project was developed as part of a network design case study for Albion University. For further details or assistance, refer to the project documentation or contact the network administrator.