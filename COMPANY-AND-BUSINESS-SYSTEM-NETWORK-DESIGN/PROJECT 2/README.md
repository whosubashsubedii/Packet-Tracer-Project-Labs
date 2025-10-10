# 🏢 Project #6 – Company/Business System Network Design & Implementation

This project involves the **design and implementation of a comprehensive network infrastructure** for a trading floor support center moving into a new building. With a total of 600+ users and mission-critical operations, the solution prioritizes **redundancy**, **scalability**, and **security** using Cisco technologies.

---

## 🏗️ Scenario Overview

A new building with **three floors** and **six departments** requires a robust network infrastructure:

- **First Floor**  
  - Sales Department (60 users)
  - Marketing Department (60 users)  
  - Human Resources Department (60 users)
  - Logistics  Department (60 users)

- **Second Floor**  
  - Finance  Department (60 users)
  - Accounts Department (60 users)  
  - Administrator Department (60 users)
  - Public Relations Department (60 users)

- **Third Floor**  
  - ICT Department (120 users)  
  - Server Room (12 devices)

---

## 🧱 Network Design Architecture

✔️ **Hierarchical Network Model**  
- Core Layer: 2 Routers (Redundant)  
- Distribution Layer: 2 Multilayer Switches (L3)  
- Access Layer: Switches per department  

✔️ **Redundancy & High Availability**  
- Dual Routers with dual ISP connections  
- Redundant uplinks between routers and switches  

✔️ **Wireless Connectivity**  
- Wireless access points deployed per department  

✔️ **VLAN & Subnetting Strategy**  
- Each department is on a **separate VLAN**  
- Subnetting from **172.16.1.0/16** based on department size  
- Devices in each subnet communicate through **inter-VLAN routing**

✔️ **IP Addressing**
- Public IPs used:  
  - `195.136.17.0/30`  
  - `195.136.17.4/30`  
  - `195.136.17.8/30`  
  - `195.136.17.12/30`  
- Private IPs dynamically assigned via **DHCP servers** (located in the Server Room)  
- Static IPs manually configured for **Server Room devices**

---

## ⚙️ Configuration Details

### 🔐 Basic Device Settings
- Hostnames  
- Console and enable passwords  
- Banner messages  
- Disabled IP domain lookup  

### 🌐 VLAN & Routing
- VLANs per department  
- IP routing on multilayer switches (Inter-VLAN Routing)  
- OSPF routing across all routers and multilayer switches  

### 🔒 Security
- **SSH** enabled for all routers and L3 switches  
- **Port-security** on Finance & Accounts department ports (sticky MAC, violation mode shutdown)  
- **PAT (Port Address Translation)** for internet access using outbound router interface IPs  
- **ACL** to permit necessary traffic for PAT  

---

## 📁 Project Assets

/Business_Network_Design/
│
├── topology.pkt # Cisco Packet Tracer Project File
├── VLAN_Subnetting.xlsx # VLAN and IP Subnetting Plan
├── device_configs/ # CLI configuration files
│ ├── router1_config.txt
│ ├── router2_config.txt
│ ├── switch1_config.txt
│ └── ...
├── network_diagram.png # Logical topology diagram
├── README.md # Project documentation
└── testing_results.md # Ping tests, SSH verification, DHCP leases


---

## 🧪 Testing & Validation

- ✅ Device-to-device communication across VLANs  
- ✅ Internet access via both ISPs  
- ✅ DHCP working for all departments  
- ✅ SSH access to all Layer 3 devices  
- ✅ Port-security enforcement in Finance department  
- ✅ ACL and PAT configuration functional  
- ✅ OSPF correctly advertising all routes  

---

## 🚀 Technologies & Protocols Used

- Cisco Packet Tracer  
- VLANs & Subnetting  
- OSPF (Open Shortest Path First)  
- SSH  
- DHCP  
- ACL (Access Control Lists)  
- PAT (Port Address Translation)  
- Port-Security  
- Inter-VLAN Routing  

---

## 🧠 Key Learning Outcomes

- End-to-end network design from planning to implementation  
- Applying **Cisco best practices** for enterprise-grade networks  
- Mastering Layer 2 & Layer 3 configurations in Cisco CLI  
- Real-world experience with VLANs, routing protocols, IP planning, and security features  

---

### 🏷️ Tags

`#Cisco` `#PacketTracer` `#NetworkDesign` `#CCNA` `#EnterpriseNetworking` `#OSPF` `#VLAN` `#InterVLANRouting` `#PortSecurity` `#PAT` `#DHCP` `#NetworkArchitecture`

---

Feel free to clone, fork, or use this project as inspiration for your own enterprise network scenarios. Contributions and feedback are welcome!
