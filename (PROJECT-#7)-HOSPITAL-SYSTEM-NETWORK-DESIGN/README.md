## 🏥 Project #7 – Secure Healthcare Network Design & Implementation for Melbourne Health Services

This project entails the **secure design and implementation of a multi-site network infrastructure** for *Melbourne Health Services* across two locations. The network supports around **600+ users**, with a strong focus on **Confidentiality, Integrity, and Availability (CIA)** using **Cisco technologies**.

---

## 🏗️ Scenario Overview

Melbourne Health Services operates two sites within the same city:

### 🏢 Headquarters (HQ)

* **Medical Lead Operation & Consultancy Services (MLOCS)** – 60 users
* **Medical Emergency and Reporting (MER)** – 60 users
* **Medical Records Management (MRM)** – 60 users
* **Information Technology (IT)** – 60 users
* **Customer Service (CS)** – 60 users
* **Guest/Waiting Area (GWA)** – 30 users

### 🏥 Branch Hospital

* **Nurses & Surgery Operations (NSO)** – 30 users
* **Hospital Labs (HL)** – 30 users
* **Human Resources (HR)** – 30 users
* **Marketing (MK)** – 30 users
* **Finance (FIN)** – 30 users
* **Guest/Waiting Area (GWA)** – 30 users

A **dedicated Server Room** at HQ (connected via access switch) hosts:

* **DHCP Server**
* **DNS Server**
* **Web Server**
* **Email Server**

---

## 🧱 Network Design Architecture

### ✔️ Hierarchical Model

* **Core Layer**: 2 Cisco Routers (1 at HQ, 1 at Branch)
* **Distribution Layer**: 2 Multilayer Switches per site
* **Access Layer**: Switches per department

### ✔️ Redundancy & WAN

* Dual ISP connections per site (4 static public IPs: `195.136.17.0/30` to `195.136.17.12/30`)
* Serial WAN connection between HQ and Branch
* Default routes configured for failover

### ✔️ Wireless Infrastructure

* Wireless Access Points per department
* Separate SSIDs per VLAN

### ✔️ VLAN & Subnetting

* **Separate VLAN per department**
* Subnetting from **192.168.100.0/16**
* IP planning based on department size (HQ: 60 users/dept, Branch: 30 users/dept)

### ✔️ IP Addressing

* **Public IPs** (for routers & PAT):

  * `195.136.17.0/30`
  * `195.136.17.4/30`
  * `195.136.17.8/30`
  * `195.136.17.12/30`
* **Private IPs**:

  * DHCP-assigned to end-user devices
  * Static IPs for servers

---

## ⚙️ Configuration Details

### 🔐 Basic Settings

* Hostnames configured
* Console & enable passwords set
* Banner MOTD
* IP domain-lookup disabled

### 🌐 VLANs & Routing

* VLANs for each department
* **Inter-VLAN Routing** on multilayer switches
* **OSPF** used across routers & L3 switches
* **Default static routes** with next-hop IPs

### 🔒 Security & Access

* **SSH** on all routers and L3 switches
* **Port Security** on Server Room switch (1 MAC/sticky, violation: shutdown)
* **Extended ACLs** to filter user access
* **IPSec VPN (Site-to-Site)**: secure encrypted communication HQ ↔ Branch
* **PAT**: public IP NAT via outbound interfaces
* **ACLs**: for VPN, PAT, and departmental restrictions

---

## 📁 Project Assets

```
/Healthcare_Network_Design/
│
├── healthcare_topology.pkt         # Cisco Packet Tracer File
├── VLAN_Subnetting_MHS.xlsx        # VLANs and Subnetting Plan
├── device_configs/
│   ├── hq_router_config.txt
│   ├── branch_router_config.txt
│   ├── hq_mls1_config.txt
│   ├── branch_mls1_config.txt
│   └── ...
├── network_diagram.png             # Logical Topology Diagram
├── README.md                       # Documentation & Configuration Summary
└── test_results.md                 # Communication, VPN & Security Validation Logs
```

---

## 🧪 Testing & Validation

✅ End-to-end VLAN communication
✅ VPN encryption active (HQ ↔ Branch)
✅ DHCP leases successfully assigned
✅ SSH login access to all Layer 3 devices
✅ PAT working with ACL support
✅ Port security triggered when policy violated
✅ OSPF routes advertised and reachable
✅ ACLs correctly limiting traffic per policy

---

## 🚀 Technologies & Protocols Used

* **Cisco Packet Tracer**
* VLANs & Subnetting
* **OSPF** (Open Shortest Path First)
* **SSH**
* **DHCP / Static IP**
* **ACL (Access Control Lists)**
* **PAT (Port Address Translation)**
* **IPSec VPN**
* **Port-Security**
* **Inter-VLAN Routing**
* **Serial WAN Connections**
* **Hierarchical Model with Redundancy**

---

## 🧠 Key Learning Outcomes

* Designing secure multi-site healthcare networks
* Implementing Layer 2 & Layer 3 Cisco best practices
* Mastering VLANs, OSPF, VPNs, ACLs, and Port Security
* Real-world use of site-to-site encryption (IPSec)
* Planning scalable IP addressing and high availability

---

## 🏷️ Tags

\#Cisco #HealthcareNetwork #PacketTracer #NetworkSecurity #OSPF #VPN #ACL #IPSec #VLAN #PAT #PortSecurity #DHCP #NetworkArchitecture #Confidentiality #Integrity #Availability
