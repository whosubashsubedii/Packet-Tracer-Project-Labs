
---

# University Network Configuration

## Overview

This project implements a robust and scalable network infrastructure for **Albion University**, a large educational institution with two campuses located 20 miles apart. The design supports secure, efficient connectivity across multiple departments and faculties, using Cisco Packet Tracer for simulation and implementation.

The network includes:

* VLAN-based segmentation per department/faculty
* Inter-VLAN routing (Router-on-a-Stick)
* DHCP for dynamic addressing
* RIPv2 for dynamic routing
* SSH for secure remote access
* Static routing for cloud-based services (e.g., email server)

---

## Network Layout

### 📍 Main Campus

* **Building A**

  * Administrative Staff (Management, HR, Finance)
  * Faculty of Business
  * Uses VLANs and a DHCP server on the router for IP allocation

* **Building B**

  * Faculty of Engineering and Computing
  * Faculty of Art and Design

* **Building C**

  * Student Labs
  * IT Department (hosts web server and other internal servers)

### 🏥 Branch Campus

* Faculty of Health and Sciences
* Staff and student labs located on separate floors
* Operates independently but connects back to the Main Campus via a point-to-point WAN link

---

## IP Addressing and VLANs

| VLAN  | Department/Location                  | Subnet          |
| ----- | ------------------------------------ | --------------- |
| 10    | Admin Staff                          | 192.168.1.0/24  |
| 20    | HR Department                        | 192.168.2.0/24  |
| 30    | Finance Department                   | 192.168.3.0/24  |
| 40    | Faculty of Business                  | 192.168.4.0/24  |
| 50    | Faculty of Engineering and Computing | 192.168.5.0/24  |
| 60    | Faculty of Art and Design            | 192.168.6.0/24  |
| 70    | Student Labs (Main Campus)           | 192.168.7.0/24  |
| 80    | IT Department                        | 192.168.8.0/24  |
| 90    | Staff (Branch Campus)                | 192.168.9.0/24  |
| 100   | Student Labs (Branch Campus)         | 192.168.10.0/24 |
| WAN   | Main ↔ Branch Campus                 | 10.10.10.0/30   |
| WAN   | Main Campus ↔ Cloud                  | 10.10.10.4/30   |
| Cloud | Email Server Network                 | 20.0.0.0/30     |

---

## Technologies Used

### Devices

* Cisco **2911** Routers
* Cisco **3650-24PS** Layer 3 Switches
* Cisco **2960-24T** Layer 2 Switches
* Server-PT, PCs, laptops, printers

### Protocols & Services

* **RIPv2** for dynamic routing
* **Static Routing** for external connectivity
* **DHCP** via router-based pools
* **SSH** for secure device management
* **VLANs** and **Router-on-a-Stick** for inter-VLAN routing

### Cabling

* Copper Straight-Through (PC ↔ Switch / Switch ↔ Router)
* Copper Cross-Over (Switch ↔ Switch)
* Serial DCE (Router ↔ Router)

---

## Key Configurations

### VLAN Interface Example (on Switch)

```bash
interface vlan 10
 ip address 192.168.1.254 255.255.255.0
exit
ip default-gateway 192.168.1.1
```

### Router Subinterface (Router-on-a-Stick)

```bash
interface gig0/0.10
 encapsulation dot1Q 10
 ip address 192.168.1.1 255.255.255.0
exit
```

### DHCP Pool Configuration (Router)

```bash
ip dhcp pool HR_Department
 network 192.168.2.0 255.255.255.0
 default-router 192.168.2.1
 dns-server 192.168.2.1
exit
```

### RIPv2 Configuration (Main Campus)

```bash
router rip
 version 2
 network 192.168.1.0
 network 10.10.10.0
exit
```

### SSH Setup on Switch

```bash
hostname HR_Switch
ip domain-name hr.albion.edu
username admin password cisco
crypto key generate rsa
ip ssh version 2
line vty 0 15
 login local
 transport input ssh
```

---

## How to Deploy in Packet Tracer

1. **Add Devices**

   * Use Cisco routers, switches, PCs, and servers as per building layout.

2. **Connect Devices**

   * Use correct cabling types (straight-through, crossover, serial DCE).

3. **Configure VLANs and Assign Ports**

   * One VLAN per department/faculty.
   * Assign access ports on switches.

4. **Configure Router-on-a-Stick**

   * Create subinterfaces for each VLAN on the main router.

5. **Enable DHCP on Routers**

   * Configure one pool per department.

6. **Set Up RIPv2**

   * Advertise all internal networks.

7. **Configure SSH on Switches**

   * Set hostname, domain, username, enable SSH, and secure access.

8. **Add Static Routes**

   * Enable external email server access from internal network.

9. **Test the Network**

   * Use `ping`, `ipconfig`, and routing tables to verify:

     * Inter-VLAN communication
     * DHCP address allocation
     * SSH login
     * Internet/cloud access via static route

---

## File Structure

```
/albion-university-network/
├── CAMPUS-UNIVERSITY-SYSTEM-NETWORK-DESIGN.pkt                     # Packet Tracer file
├── DESIGN-OF-A-CAMPUS-UNIVERSITY-SYSTEM-NETWORK-DESIGN.png          # Design file
└── README.md                                                       # This file
```

---

## Troubleshooting Tips

* Verify that trunk links are correctly configured between switches and router.
* Check that subinterfaces are active using `show ip interface brief`.
* Confirm VLAN assignment with `show vlan brief`.
* Test DHCP with `ipconfig /renew` on PCs.
* Save all device configurations using `write memory` or `copy run start`.

---

## Author

Developed as a case study for Albion University’s campus-wide network infrastructure using Cisco technologies and Packet Tracer simulation.

---