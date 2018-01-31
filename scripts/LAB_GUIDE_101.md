
# OPENSTACK FOR NETWORK ENGINEERS
# Intructor Led Lab (#LTRCLD-1451)
# Cisco Live 2018, Barcelona

|Luis Rueda             |               Gopal Naganaboyina|
|:----------------------|--------------------------------:|

---

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [OPENSTACK FOR NETWORK ENGINEERS](#openstack-for-network-engineers)
- [Intructor Led Lab (#LTRCLD-1451)](#intructor-led-lab-ltrcld-1451)
- [Cisco Live 2018, Barcelona](#cisco-live-2018-barcelona)
- [Welcome](#welcome)
	- [Introduction](#introduction)
	- [Lab structure](#lab-structure)
	- [Questions](#questions)
	- [Openstack Installation](#openstack-installation)
	- [Join the Discussion at Cisco Spark](#join-the-discussion-at-cisco-spark)
- [Introduction to OpenStack](#introduction-to-openstack)
- [Credentials](#credentials)
- [Lab Connectivity](#lab-connectivity)
	- [Physical Topology](#physical-topology)
	- [Logical Topology](#logical-topology)
	- [Connectivity](#connectivity)
	- [Testing VPN Lab Connectivity](#testing-vpn-lab-connectivity)
- [Openstack Cloud High Level View](#openstack-cloud-high-level-view)
	- [Command Line Interface (CLI)](#command-line-interface-cli)
	- [Horizon dashboard](#horizon-dashboard)
- [Admin Tasks](#admin-tasks)
	- [Scenario](#scenario)
	- [Source keystone_adminrc File](#source-keystoneadminrc-file)
	- [Flavors](#flavors)
	- [Provider Network and Subnet](#provider-network-and-subnet)
	- [Images](#images)
	- [Floating IP Pool](#floating-ip-pool)
- [Tenant Tasks](#tenant-tasks)
	- [Tenant Networks and Subnets](#tenant-networks-and-subnets)
		- [Internet Network and Subnet](#internet-network-and-subnet)
		- [Internal Network and Subnet](#internal-network-and-subnet)
	- [OpenStack Router](#openstack-router)
		- [Internet Network on OpenStack Router](#internet-network-on-openstack-router)
	- [Instances](#instances)
		- [Security Groups](#security-groups)
		- [CSR1Kv Instance](#csr1kv-instance)
			- [Additional CSR1Kv Configuration](#additional-csr1kv-configuration)
			- [Assign Floating IP to CSR1Kv](#assign-floating-ip-to-csr1kv)
		- [CirrOS Instance](#cirros-instance)
	- [Allowed Address Pairs](#allowed-address-pairs)
	- [Return Routes for OpenStack Router](#return-routes-for-openstack-router)
- [Neutron Intensive Tasks](#neutron-intensive-tasks)
	- [Topology](#topology)
	- [Packet Path](#packet-path)
	- [Packet Tracing Tasks](#packet-tracing-tasks)
- [OpenStack Review Tasks](#openstack-review-tasks)
- [Resources](#resources)
	- [Openstack Neutron VOD](#openstack-neutron-vod)
	- [Cisco Devnet](#cisco-devnet)
	- [Openstack lab video](#openstack-lab-video)
	- [Video on Neutron](#video-on-neutron)
	- [Openstack solutions at cisco](#openstack-solutions-at-cisco)

<!-- /TOC -->

---

# Welcome

## Introduction
* Speaker intro: Luis Rueda, Gopal Naganaboyina
* Participant current skill level, lab expectations.
* This is OpenStack from a network admin/engineer perspective

## Lab structure
* There are 6 hands-on sections, with an estimated completion time of 3 hr. 30 min.
* Every section has estimated time to complete. This is an estimate only. Please feel free to spend as much time as you like.
* We recommend you to take a quick break at 2 hr. mark, at 4:00PM.
* Overall idea and flow of the lab

## Questions
* Questions are most welcome. We **request** you to ask questions and make the session interactive.
* Self exploration is fun. At the end of each section, take a few minutes to review and ask questions if you have any.

## Openstack Installation
* Openstack installation is not included in this session to make efficient use of time.
* If installation is successful, there is not much to learn. If not successful, there won't be enough time within this session to troubleshoot.
* For this lab, we used Packstack installer on CentOS7.4. This is a multi-node installation, with one Controller and 6 Compute nodes. One biggest problem we encountered was copy-time-out.

## Join the Discussion at Cisco Spark
A spark room has been created and will be kept for about a week after the session. Please share any questions, comments or feedback.
* Go to [spark](http://cs.co/ciscolivebot#LTRCLD-1451) and add your email address
* Select Spark installed/not-installed based on whether your device (phone/laptop) has Spark or not.

---

# Introduction to OpenStack

Refer to [slides](./pdfs/Introduction_to_OpenStack_v1.pdf) presented.

---

# Credentials

You will be given a paper copy of IP addresses, username, password info.

---

# Lab Connectivity
*Estimated time to complete: 15 min.*

All the tasks in this guide can be done using OpenStack CLI or OpenStack Horizon's Dashboard, the examples will be using either one of them and it is up to the student to explore the different ways of doing it using the alternate method.

*Note: It is also possible to do things using other methods such as API or high level python libraries.*

Please note that a typical production NFV system or Openstack cloud includes components such as exclusive storage, DPDK network connectivity with PCIe or SR-IOv, OSS/BSS system, VNF management system, and Orchestration systems. In this lab, we have Openstack alone, which makes up ETSI model’s Virtual Infrastructure Manager (VIM).

The lab is built with 7 Cisco UCS C240 servers. The lab is behind a VPN server. To access the lab, you need to VPN into the VPN server. The VPN server and the lab are in USA and the access to VPN server is over Internet.

## Physical Topology

Access to the lab is over VPN tunnel. When you create the tunnel, VPN server will advertise a few routes to your laptop.

![Physical Toplogy](./images/lab_walkthrough_hw_topology_00.png)

## Logical Topology

No other nodes except Openstack Controller has connectivity to external-VLAN and hence to Internet. Your access to Openstack cloud, which includes Compute nodes is through Controller.

Provider data center services and customer’s hypothetical CPE connections are shown to represent typical branch office access to Openstack cloud services. Branch office tasks are excluded to manage time.

![Logical Topology](./images/lab_walkthrough_connectivity_00.png)

## Connectivity

Below is a representation of Openstack cloud connectivity to the external networks. You will access the Controller over Internet. And, this cloud uses provider-VLAN (just a name) to reach: 1. Service Provider services, and 2. Customers’ branch office sites.

![Logical Topology](./images/lab-walkthrough-connectivity.png)

## Testing VPN Lab Connectivity

- VPN into lab gateway: Using **Cisco AnyConnect VPN** client app, VPN into the lab gateway. It will setup a VPN tunnel and will install a few routes in your workstation. Use below details:

	- IP address: Refer credentials doc
	- Username: Refer credentials doc
	- Password: Refer credentials doc

![Cisco VPN](./images/lab_walkthrough_connectivity_step_01.png)

- Verify routing on your desktop and check connectivity to Openstack controller

	- `ping 172.31.56.216`
	- If ping succeeds, open the following link in a new tab: [http://172.31.56.216](http://172.31.56.216), no need to login to the portal, just ensure you get to the login screen.
	- If ping fails, check if you have 1) successfully VPN into the lab VPN-server and 2) you have a route to 172.31.56.0/24. Windows command to list route table: `route print`

*Review the section and discuss if you have any questions or comments.*

---

# Openstack Cloud High Level View
*Estimated time to complete: 15 min.*

Use command line interface (CLI) and Horizon dashboard and try to get a overall view of the Openstack cloud that we are going to use.

## Command Line Interface (CLI)

* login into Controller node: `ssh tenant101@172.31.56.216`
	* Use **putty** app provided in your lab laptop
	* IP address: `172.31.56.216`
	* username: `tenant101`
	* password: `cisco.123`
* Load environment parameters for Openstack access: `$ source keystonerc_admin101`
* Try the below commands:
	* `openstack-status`
	* `openstack-service list`
	* `openstack-service status`
	* `openstack hypervisor list`
	* `openstack hypervisor stats show`
	* `openstack usage list`

## Horizon dashboard

* Login into Horizon dashboard using the credentials below:
	* URL: `http://172.31.56.216`
	* username: `admin101`
	* password: `cisco.123`
* On the left pane, go to Admin -> Overview
	* Observe VCPUs, RAM, etc. resource usage.
* On the left pane, go to: Admin -> Compute -> Hypervisors
	* On the "Hypervisor" tab, observe total and used resources.
	* On the "Compute host" tab, observe "Status" of different hosts.

*Review the section and discuss if you have any questions or comments.*

---

# Admin Tasks
*Estimated time to complete: 45 min.*

## Scenario

In this section, you would assume the role of an administrator of an OpenStack cloud. The goal is to create all the necessary elements for your users to be able to later create a virtual machine and make some basic verifications. This exercise exposes typical OpenStack admin environment.

* FYI
	* Your Linux username is: tenant101
	* Your Openstack username/profile with admin privileges: admin101
	* Your Openstack username/profile with member privileges: user101
	* Your project name is: tenant101

The following diagram depicts the topology:
![Topolgy](./images/admin_tasks_topology_01.png)

## Source keystone_adminrc File

For all the commands that are executed using OpenStack CLI the first thing that need to be done is to source all the necessary variables that will allow us to authenticate with OpenStack.

```
$ source ~/keystonerc_admin101
```

## Flavors
Lets start by creating some flavors that will be required for our VNFs (Virtual Machines).

A flavor is required for each of the following:

| flavor-name | vCPUs | vRAM (MB) | vDisk (GB) |
|--------------|:-------:|:-----------:|:------------:|
| tenant101-csr1kv.small | 2 | 4096 | 0 |
| tenant101-m1.nano | 1 | 64 | 1 |

*Note: You need to execute the procedure for all the flavors in the table. The procedure is explained for one flavor but the same procedure is valid for all of them.
In order to create a flavor with with 1 vCPU, 64 MB of vRAM and 1 GB of vDisk with a name of tenant101-m1.nano available to tenant101, the following command would be used:

* `openstack flavor create --project <project-name> --ram <RAM in MB> --vcpus <# of VCPUs> --disk <disk size GB> --private <flavor-name>`

Example:

```
$ openstack flavor create --project tenant101 --ram 64 --vcpus 1 --disk 1 --private tenant101-m1.nano
+----------------------------+--------------------------------------+
| Field                      | Value                                |
+----------------------------+--------------------------------------+
| OS-FLV-DISABLED:disabled   | False                                |
| OS-FLV-EXT-DATA:ephemeral  | 0                                    |
| disk                       | 1                                    |
| id                         | 4382f519-24c2-4cff-8b94-cc22537dcd3c |
| name                       | tenant101-m1.nano                     |
| os-flavor-access:is_public | False                                |
| properties                 |                                      |
| ram                        | 64                                   |
| rxtx_factor                | 1.0                                  |
| swap                       |                                      |
| vcpus                      | 1                                    |
+----------------------------+--------------------------------------+

$ openstack flavor create --project tenant101 --ram 4096 --vcpus 2 --disk 0 --private tenant101-csr1kv.small
+----------------------------+--------------------------------------+
| Field                      | Value                                |
+----------------------------+--------------------------------------+
| OS-FLV-DISABLED:disabled   | False                                |
| OS-FLV-EXT-DATA:ephemeral  | 0                                    |
| disk                       | 0                                    |
| id                         | 23089d44-9c54-4a4f-8ba9-8872091c1662 |
| name                       | tenant101-csr1kv.small              |
| os-flavor-access:is_public | False                                |
| properties                 |                                      |
| ram                        | 4096                                 |
| rxtx_factor                | 1.0                                  |
| swap                       |                                      |
| vcpus                      | 2                                    |
+----------------------------+--------------------------------------+
```

*Note: there are many other options that can be specified, these options can be explored by executing `openstack flavor create --help` command*

*Note: Replace 101 with your POD number. You will have this in your handout page*

## Provider Network and Subnet

Lets start by creating one provider network using the admin user, Only the admin users will have administrative control over the OpenStack Cloud network.

The values for Segmentation ID, Network Address, Gateway IP and Allocation Pools can be found in the following table, for **Physical Network** use **physnet1** for all students:

| Tenant | Segmentation ID | Network Address | Gateway IP | Allocation Pools | Physical Network |
|-----------|-----|-----------------|--------------|-------------------------------|----------|
| Tenant101 | 201 | 172.16.201.0/24 | 172.16.201.1 | 172.16.201.2 - 172.16.201.254 | physnet1 |
| Tenant102 | 202 | 172.16.202.0/24 | 172.16.202.1 | 172.16.202.2 - 172.16.202.254 | physnet1 |
| Tenant103 | 203 | 172.16.203.0/24 | 172.16.203.1 | 172.16.203.2 - 172.16.203.254 | physnet1 |
| Tenant104 | 204 | 172.16.204.0/24 | 172.16.204.1 | 172.16.204.2 - 172.16.204.254 | physnet1 |
| Tenant105 | 205 | 172.16.205.0/24 | 172.16.205.1 | 172.16.205.2 - 172.16.205.254 | physnet1 |
| Tenant106 | 206 | 172.16.206.0/24 | 172.16.206.1 | 172.16.206.2 - 172.16.206.254 | physnet1 |
| Tenant107 | 207 | 172.16.207.0/24 | 172.16.207.1 | 172.16.207.2 - 172.16.207.254 | physnet1 |
| Tenant108 | 208 | 172.16.208.0/24 | 172.16.208.1 | 172.16.208.2 - 172.16.208.254 | physnet1 |
| Tenant109 | 209 | 172.16.209.0/24 | 172.16.209.1 | 172.16.209.2 - 172.16.209.254 | physnet1 |
| Tenant110 | 210 | 172.16.210.0/24 | 172.16.210.1 | 172.16.210.2 - 172.16.210.254 | physnet1 |
| Tenant111 | 211 | 172.16.211.0/24 | 172.16.211.1 | 172.16.211.2 - 172.16.211.254 | physnet1 |
| Tenant112 | 212 | 172.16.212.0/24 | 172.16.212.1 | 172.16.212.2 - 172.16.212.254 | physnet1 |
| Tenant113 | 213 | 172.16.213.0/24 | 172.16.213.1 | 172.16.213.2 - 172.16.213.254 | physnet1 |
| Tenant114 | 214 | 172.16.214.0/24 | 172.16.214.1 | 172.16.214.2 - 172.16.214.254 | physnet1 |
| Tenant115 | 215 | 172.16.215.0/24 | 172.16.215.1 | 172.16.215.2 - 172.16.215.254 | physnet1 |
| Tenant116 | 216 | 172.16.216.0/24 | 172.16.216.1 | 172.16.216.2 - 172.16.216.254 | physnet1 |
| Tenant117 | 217 | 172.16.217.0/24 | 172.16.217.1 | 172.16.217.2 - 172.16.217.254 | physnet1 |
| Tenant118 | 218 | 172.16.218.0/24 | 172.16.218.1 | 172.16.218.2 - 172.16.218.254 | physnet1 |
| Tenant119 | 219 | 172.16.219.0/24 | 172.16.219.1 | 172.16.219.2 - 172.16.219.254 | physnet1 |
| Tenant120 | 220 | 172.16.220.0/24 | 172.16.220.1 | 172.16.220.2 - 172.16.220.254 | physnet1 |
| Tenant121 | 221 | 172.16.221.0/24 | 172.16.221.1 | 172.16.221.2 - 172.16.221.254 | physnet1 |
| Tenant122 | 222 | 172.16.222.0/24 | 172.16.222.1 | 172.16.222.2 - 172.16.222.254 | physnet1 |
| Tenant123 | 223 | 172.16.223.0/24 | 172.16.223.1 | 172.16.223.2 - 172.16.223.254 | physnet1 |
| Tenant124 | 224 | 172.16.224.0/24 | 172.16.224.1 | 172.16.224.2 - 172.16.224.254 | physnet1 |
| Tenant125 | 225 | 172.16.225.0/24 | 172.16.225.1 | 172.16.225.2 - 172.16.225.254 | physnet1 |
| Tenant126 | 226 | 172.16.226.0/24 | 172.16.226.1 | 172.16.226.2 - 172.16.226.254 | physnet1 |
| Tenant127 | 227 | 172.16.227.0/24 | 172.16.227.1 | 172.16.227.2 - 172.16.227.254 | physnet1 |
| Tenant128 | 228 | 172.16.228.0/24 | 172.16.228.1 | 172.16.228.2 - 172.16.228.254 | physnet1 |
| Tenant129 | 229 | 172.16.229.0/24 | 172.16.229.1 | 172.16.229.2 - 172.16.229.254 | physnet1 |

The other two required networks can be created with a user that has _member_ privileges, but can also be created using this admin user if desired.

Step 1 - Go to Admin -> Network -> Networks and click on **Create Network**
![Step 1](./images/admin_network_provider_create_01.png)

Step 2 - Fill in all the values for the network and click on **Next**
![Step 2](./images/admin_network_provider_create_02.png)

Step 3 - Fill in all the values for the subnet and click on **Next**
![Step 3](./images/admin_network_provider_create_03.png)

Step 4 - Fill in all the values for the subnet details (pool is comma separated) and click on **Create**
![Step 4](./images/admin_network_provider_create_04.png)

Step 5 - A green notification should appear on the top-right corner indicating successful creation of the network and subnet
![Step 5](./images/admin_network_provider_create_05.png)

## Images

We need to create the following images in glance.

| Image Name | Format | Shared | File Name | Disk Format |
|--------------|-------|-----------|------------|-----------|
| tenant101-csr1kv-3.16.6s | qcow2 | No | csr3.16.6s.qcow2 | qcow2 |
| tenant101-cirros-0.4.0-x86_64 | qcow2 | No | cirros-0.4.0-x86_64-disk.img | qcow2 |

Next you will find the steps to upload the image either via Horizon or OpenStack CLI.

*Note: You need to execute the procedure for all the images in the table. The procedure is explained for one image but the same procedure is valid for all of them.*

The files can be downloaded from this [link](http://172.31.56.131/download/) and from the command line they can be downloaded using wget (e.g. `wget http://172.31.56.131/download/cirros-0.4.0-x86_64-disk.img` and `wget http://172.31.56.131/download/csr3.16.6s.qcow2`)

Upload image using single OpenStack CLI command:
```
$ openstack image create --project tenant101 --disk-format qcow2 --file cirros-0.4.0-x86_64-disk.img tenant101-cirros-0.4.0-x86_64
+------------------+------------------------------------------------------+
| Field            | Value                                                |
+------------------+------------------------------------------------------+
| checksum         | 443b7623e27ecf03dc9e01ee93f67afe                     |
| container_format | bare                                                 |
| created_at       | 2018-01-10T20:54:36Z                                 |
| disk_format      | qcow2                                                |
| file             | /v2/images/51b8a82f-339a-4fb9-89f5-79a557321510/file |
| id               | 51b8a82f-339a-4fb9-89f5-79a557321510                 |
| min_disk         | 0                                                    |
| min_ram          | 0                                                    |
| name             | tenant101-cirros-0.4.0-x86_64                         |
| owner            | 1e2b5c63d1f14091b237acf064cc9db6                     |
| protected        | False                                                |
| schema           | /v2/schemas/image                                    |
| size             | 12716032                                             |
| status           | active                                               |
| tags             |                                                      |
| updated_at       | 2018-01-10T20:54:36Z                                 |
| virtual_size     | None                                                 |
| visibility       | private                                              |
+------------------+------------------------------------------------------+
```

Verify that you have both images just like in the following output:
```
$ openstack image list
+--------------------------------------+-----------------------------------+--------+
| ID                                   | Name                              | Status |
+--------------------------------------+-----------------------------------+--------+
| aaac0de7-2248-46f3-a283-775891ab888e | tenant101-cirros-0.4.0-x86_64     | active |
| 3655b9fa-e2c5-421e-b2e1-65410288d28b | tenant101-csr1kv-3.16.6s          | active |
+--------------------------------------+-----------------------------------+--------+
```
*Note: you may see more images from other tenants.*

## Floating IP Pool

We will be assigning a floating IP for our CSR1Kv, in order to do so we first need to create one. Lets create a floating IP for later assignment to CSR1Kv.

For the actual IPv4 address you can either assign a fixed one (use 172.31.57.101 and replace 101 for your POD number e.g. POD 131 would use 172.31.57.131) or let OpenStack select the IPv4 that will be assigned.

```
$ openstack floating ip create --project tenant101 --floating-ip-address 172.31.57.101 external
+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| created_at          | 2018-01-21T22:46:21Z                 |
| description         |                                      |
| fixed_ip_address    | None                                 |
| floating_ip_address | 172.31.57.101                        |
| floating_network_id | 06ca5380-84eb-46b1-b0db-8fa038f72998 |
| id                  | 958a5fd7-72ef-426a-9aef-dd6bbbac6501 |
| name                | 172.31.57.101                        |
| port_id             | None                                 |
| project_id          | 1e2b5c63d1f14091b237acf064cc9db6     |
| revision_number     | 0                                    |
| router_id           | None                                 |
| status              | DOWN                                 |
| updated_at          | 2018-01-21T22:46:21Z                 |
+---------------------+--------------------------------------+
```

*Review the section and discuss if you have any questions or comments.*

---

# Tenant Tasks
*Estimated time to complete: 90 min.*
We will now be working as a regular user of the tenant (no longer as admin).

For Horizon Dashboard, sign out of the admin101 user, and login as user101 now.

For OpenStack CLI, source keystone_user101 file, the prompt should be: `[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]#`

## Tenant Networks and Subnets

As a tenant user we will need to create two networks, one that connects CSR1Kv to the Internet and the other one that will connect the internal VM to CSR1Kv.

### Internet Network and Subnet

Lets start by creating the Internet network.

Since the Internet network does not have connectivity to the outside world (It is only relevant for the tenant) the same value can be reused by all tenants.

|  Tenant   | Network Address  |  Gateway IP   |         Allocation Pools        |
|-----------|------------------|---------------|---------------------------------|
| Tenant101 | 192.168.254.0/24 | 192.168.254.1 | 192.168.254.2 - 192.168.254.254 |

Step 1 - Go to Project -> Network -> Networks and click on **Create Network**
![Step 1](./images/member_network_internet_create_step_01.png)

Step 2 - Fill in all the values for the network and click on **Next**
![Step 2](./images/member_network_internet_create_step_02.png)

Step 3 - Fill in all the values for the subnet and click on **Next**
![Step 3](./images/member_network_internet_create_step_03.png)

Step 4 - Fill in all the values for the subnet details (pool is comma separated) and click on **Create**
![Step 4](./images/member_network_internet_create_step_04.png)

Step 5 - A green notification should appear on the top-right corner indicating successful creation of the network and subnet
![Step 5](./images/member_network_internet_create_step_05.png)

### Internal Network and Subnet

Lets create now the Internal Network. This time we will do it via OpenStack CLI.

```
$ openstack network create tenant101-internal
+---------------------------+--------------------------------------+
| Field                     | Value                                |
+---------------------------+--------------------------------------+
| admin_state_up            | UP                                   |
| availability_zone_hints   |                                      |
| availability_zones        |                                      |
| created_at                | 2018-01-22T00:27:01Z                 |
| description               |                                      |
| dns_domain                | None                                 |
| id                        | bd11919c-ed33-4229-8376-f5e063ad7f0a |
| ipv4_address_scope        | None                                 |
| ipv6_address_scope        | None                                 |
| is_default                | False                                |
| is_vlan_transparent       | None                                 |
| mtu                       | 1450                                 |
| name                      | tenant101-internal                   |
| port_security_enabled     | True                                 |
| project_id                | 1e2b5c63d1f14091b237acf064cc9db6     |
| provider:network_type     | None                                 |
| provider:physical_network | None                                 |
| provider:segmentation_id  | None                                 |
| qos_policy_id             | None                                 |
| revision_number           | 2                                    |
| router:external           | Internal                             |
| segments                  | None                                 |
| shared                    | False                                |
| status                    | ACTIVE                               |
| subnets                   |                                      |
| tags                      |                                      |
| updated_at                | 2018-01-22T00:27:01Z                 |
+---------------------------+--------------------------------------+

$ openstack subnet create --network tenant101-internal --subnet-range 192.168.255.0/24 tenant101-internal-subnet
+-------------------------+--------------------------------------+
| Field                   | Value                                |
+-------------------------+--------------------------------------+
| allocation_pools        | 192.168.255.2-192.168.255.254        |
| cidr                    | 192.168.255.0/24                     |
| created_at              | 2018-01-22T00:46:22Z                 |
| description             |                                      |
| dns_nameservers         |                                      |
| enable_dhcp             | True                                 |
| gateway_ip              | 192.168.255.1                        |
| host_routes             |                                      |
| id                      | 2bb680e4-2da0-4f51-9b52-ad41e006ad43 |
| ip_version              | 4                                    |
| ipv6_address_mode       | None                                 |
| ipv6_ra_mode            | None                                 |
| name                    | tenant101-internal-subnet            |
| network_id              | 2f25227b-80b0-4f31-b11b-9b2d8066127c |
| project_id              | 1e2b5c63d1f14091b237acf064cc9db6     |
| revision_number         | 0                                    |
| segment_id              | None                                 |
| service_types           |                                      |
| subnetpool_id           | None                                 |
| tags                    |                                      |
| updated_at              | 2018-01-22T00:46:22Z                 |
| use_default_subnet_pool | None                                 |
+-------------------------+--------------------------------------+
```

Since the Internal network does not have connectivity to the outside world, the same value can be reused by all tenants.

|   Tenant  | Network Address  |  Gateway IP   |         Allocation Pools        |
|-----------|------------------|---------------|---------------------------------|
| Tenant101 | 192.168.255.0/24 | 192.168.255.1 | 192.168.255.2 - 192.168.255.254 |

## OpenStack Router
In order to allow connectivity to the Internet, OpenStack allows us to have an external network which would be connected to an OpenStack router that will do NAT as well as some other functions.

Lets create an OpenStack router.

Step 1 - Go to Project -> Network -> Routers and click on **Create Router**
![Step 1](./images/member_routers_create_step_01.png)

Step 2 - Fill in all the values for the router and click on **Create Router** button
![Step 2](./images/member_routers_create_step_02.png)

Step 3 - A green notification should appear on the top-right corner indicating successful creation of the router
![Step 3](./images/member_routers_create_step_03.png)

### Internet Network on OpenStack Router
When creating the OpenStack router we defined the external facing interface for that router. We will need to attach the internal facing interface for our router which is called tenant101-internet. Lets attach that interface to the router.

Step 1 - Go to Project -> Network -> Routers and click on the router that was created in the previous step, go to the Interfaces tab and click on **Add Interface**
![Step 1](./images/member_routers_attach_interface_internet_step_01.png)

Step 2 - Select tenant101-internet from the drop-down list of subnets and click on **Submit**
![Step 2](./images/member_routers_attach_interface_internet_step_02.png)

Step 3 - A green notification should appear on the top-right corner indicating successful attach of the subnet to the router
![Step 3](./images/member_routers_attach_interface_internet_step_03.png)

## Instances

### Security Groups

In order for our CSR1Kv instance to work properly, we have to create a security group and allow all inbound traffic that is desired. For the purpose of our lab, we will create multiple security groups so that they can be easily identifiable.

The following table lists the security groups that need to be created:

| Security Group Name  | Rule | Direction | Remote | CIDR |
|----------------------|:------:|:-----------:|:--------:|------|
| tenant101-allow_ssh  | SSH  | N/A       | CIDR   | 0.0.0.0/0 |
| tenant101-allow_icmp | ALL ICMP | Ingress | CIDR | 0.0.0.0/0 |

Step 1 - Go to Project -> Network -> Security Groups and click on **Create Security Group**.
![Step 1](./images/member_create_security_groups_step_01.png)

Step 2 - Type the security group name (do not forget to replace 101 with your POD number) and click on **Create Security Group**.
![Step 2](./images/member_create_security_groups_step_02.png)

Step 3 - A green notification should appear on the top-right corner indicating successful creation of the security group.
![Step 3](./images/member_create_security_groups_step_03.png)

Step 4 - Click on **Manage Rules** for the security group that was just created.
![Step 4](./images/member_create_security_groups_step_04.png)

Step 5 - Click on **Add Rule**.
![Step 5](./images/member_create_security_groups_step_05.png)

Step 6 - Fill in the values based on the above table and click on **Add**.
![Step 6](./images/member_create_security_groups_step_06.png)

Step 7 - A green notification should appear on the top-right corner indicating successful add of the security group rule.
![Step 7](./images/member_create_security_groups_step_07.png)

We will be attaching the security groups to the instance when creating the instance.

### CSR1Kv Instance

There are several steps required to create the instance, and there are multiple ways to do this. The suggested way is via OpenStack CLI, this will allow us to create the instance with a single command and provide all the proper IPv4 addresses.

Step 1 - Download the CSR1Kv Day 0 configuration file.
```
$ wget http://172.31.56.131/download/csr1kv-day0.txt
```

Step 2 - Issue the `openstack network list` command to find the IDs for the networks that we want to attach to CSR1Kv.
```
$ openstack network list
+--------------------------------------+--------------------+--------------------------------------+
| ID                                   | Name               | Subnets                              |
+--------------------------------------+--------------------+--------------------------------------+
| 06ca5380-84eb-46b1-b0db-8fa038f72998 | external           | 9b34213c-eff1-4008-a387-d08ee49b5ee0 |
| 2c3d2f04-41ed-4c1a-956d-e57f61758f1e | tenant101-internet | 49eaed11-788e-41dd-8823-12964c9f90e5 |
| 2f25227b-80b0-4f31-b11b-9b2d8066127c | tenant101-internal | 2bb680e4-2da0-4f51-9b52-ad41e006ad43 |
| 631e32e7-8e1f-42fb-a927-ec1d7dc31293 | tenant-net         | f57b9855-42fb-406a-bb31-c25036078f07 |
| 90c70132-0ea7-4362-8ab4-aff50986d012 | tenant101-provider | e7210532-3d56-4eaf-9826-0711756ad3f4 |
+--------------------------------------+--------------------+--------------------------------------+
```

Step 3 - After the networks have been identified, replace each net-id with the corresponding ID found with in *Step 2*
```
openstack server create \
   --flavor tenant101-csr1kv.small \
   --image tenant101-csr1kv-3.16.6s  \
   --nic net-id=2c3d2f04-41ed-4c1a-956d-e57f61758f1e,v4-fixed-ip=192.168.254.10 \
   --nic net-id=90c70132-0ea7-4362-8ab4-aff50986d012,v4-fixed-ip=172.16.201.10 \
   --nic net-id=2f25227b-80b0-4f31-b11b-9b2d8066127c,v4-fixed-ip=192.168.255.1 \
   --security-group tenant101-allow_ssh \
   --security-group tenant101-allow_icmp \
   --security-group default \
   --config-drive True \
   --file iosxe_config.txt=csr1kv-day0.txt \
   tenant101-csr1kv
```

*Note: for tenant101-provider replace the IPv4 address with the correct network from the tenant101-provider network.*
*Note: do not use the provided flavor in the example, replace this with your tenant101 flavors and images.*
*Note: the reason why it states 201 is because the IPv4 address is different, 201 = 101 + 100*

#### Additional CSR1Kv Configuration

We provided some configuration to the VNF via its Day-0 configuration (csr1kv-day0.txt file), we could pass anything required via that file but in order to show how we would connect to the VNF via SSH, we can ssh to it by taking advantage of the netns command.

Step 1 - Wait until VNF boots with and applied Day 0 configuration (this means that you should get a ping reply)
```
$ sudo ip netns exec qrouter-`openstack router list | grep -e "tenant.*router" | awk '{ print $2 }'` ping 192.168.254.10
```

Step 2 - Connect to the VNF via SSH
```
$ sudo ip netns exec qrouter-`openstack router list | grep -e "tenant.*router" | awk '{ print $2 }'` ssh cisco@192.168.254.10
```

The output would look something like this:
```
The authenticity of host '192.168.254.10 (192.168.254.10)' can't be established.
RSA key fingerprint is SHA256:V7Gm+BrHaOh0fNWRr0I6pLEGZMmrSBLSKykgoQQQufI.
RSA key fingerprint is MD5:99:e6:b8:b5:8c:8f:17:5c:de:86:71:28:7b:c4:b5:8a.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.254.10' (RSA) to the list of known hosts.
C
Please use password cisco to login to CSR1Kv-VNF
Password:

csr1000v-vnf#
```
*Notes:
 - Make sure you aware that linux may ask you for two passwords, the first is the password for your user (required for sudo) and the other one is Password for the Device.
 - If for some reason you did not use 192.168.254.10 or changed the username to login to the device please make adjustments to the command above.*

Step 2 - Change the IPv4 address for GigabitEthernet2
```
configure terminal
interface GigabitEthernet 2
ip address 172.16.201.10 255.255.255.0
exit
ip route 172.16.0.0 255.255.0.0 172.16.201.1
end
copy running-config startup-config

```

It would look something like this:
```
csr1000v-vnf#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
csr1000v-vnf(config)#interface GigabitEthernet 2
csr1000v-vnf(config-if)#ip address 172.16.201.10 255.255.255.0
csr1000v-vnf(config-if)#exit
csr1000v-vnf(config)#ip route 172.16.0.0 255.255.0.0 172.16.201.1
csr1000v-vnf(config)#end
csr1000v-vnf#copy running-config startup-config
Destination filename [startup-config]?
Building configuration...
[OK]
```
*Note: it is also possible to do this by getting to the NoVNC console but it will be simpler to just paste the commands via ssh. Please adjust the IPv4 address to the same IPv4 address used when creating the CSR1Kv instance.*

#### Assign Floating IP to CSR1Kv
In order for someone to be able to access CSR1Kv from the Internet, we need to assign the floating IP created before to our CSR1Kv. Lets assign the floating IP to our instance.

Step 1 - Go to Project -> Compute -> Instances and click on the dropdown box to the right of the CSR1Kv instance, select **Associate Floating IP**
![Step 1](./images/member_assign_floating_ip_step_01.png)

Step 2 - Click on the drop down box and select the IPv4 address that was assigned when [Allocating the Floating IP from pool](#floating-ip-pool)
![Step 2](./images/member_assign_floating_ip_step_02.png)

Step 3 - A green notification should appear on the top-right corner indicating successful assignment of the IPv4 address to the instance
![Step 3](./images/member_assign_floating_ip_step_03.png)

### CirrOS Instance

In order to test connectivity from behind the CSR1Kv, we will be creating a CirrOS instance that will act as our PC in the topology.

This time we will launch the CirrOS VM from the horizon dashboard.

Step 1 - Go to Project -> Compute -> Instances and click on **Launch Instance**
![Step 1](./images/member_create_instance_step_01.png)

Step 2 - Fill in all the details and click on **Next** button
![Step 2](./images/member_create_instance_step_02.png)

Step 3 - Fill in all the details for source and click on **Next** button
![Step 3](./images/member_create_instance_step_03.png)

Step 4 - Fill in all the details for flavor and click on **Next** button
![Step 4](./images/member_create_instance_step_04.png)

Step 5 - Fill in all the details for networks and click on **Next** button
![Step 5](./images/member_create_instance_step_05.png)

Step 6 - Don't fill anything on Network Ports and click on **Next** button
![Step 6](./images/member_create_instance_step_06.png)

Step 7 - Add the security groups and click on **Launch Instance** button
![Step 7](./images/member_create_instance_step_07.png)

Step 8 - A green notification should appear on the top-right corner indicating successful creation of the instance
![Step 8](./images/member_create_instance_step_08.png)

## Allowed Address Pairs

Now lets go to CirrOS console and try to execute a ping from it to the CSR1Kv interface (`ping 192.168.255.1`).

Step 1 - Go to Project -> Compute -> Instances and click on the drop down box at the right of the tenant101-pc instance and select **Console**
![Step 1](./images/member_cirros_console_01.png)

Step 2 - Click on the gray bar (cursor will not change but click on it), you will be at the instance's console.
![Step 2](./images/member_cirros_console_02.png)

You will notice that ping will work (if this is not working, ensure that you attached the allow_icmp security group, if everything else fails, go [here](#neutron-intensive-tasks)).

However if from the CirrOS instance you try to ping the IPv4 address of tenant101-provider network, it will fail. Can you figure out why it is failing ? Hint: It does not have anything to do with routing.

The problem happens because by default OpenStack will create a rule for the newly created port, stating that only traffic going to the port's IPv4 address is allowed. This behavior although desired when using OpenStack for server instances, is not desirable for VNFs because traffic may be routed through the VNF but may not be intended to the VNF itself (think of a router that routes IPv4 packets destined to other networks).

To correct this problem we have to identify the ports of the router and change add a filter to allow traffic going to any IPv4 network (i.e. 0.0.0.0/0).

To do that we will use the OpenStack CLI.

Step 1 - Identify the port that requires changes (since our CSR1Kv VNF has three ports, we will need to execute the procedure in each one of them)
```
$ openstack port list
+--------------------------------------+------+-------------------+------------------------------------------------------------------------------+--------+
| ID                                   | Name | MAC Address       | Fixed IP Addresses                                                           | Status |
+--------------------------------------+------+-------------------+------------------------------------------------------------------------------+--------+
| 325e6e70-eccf-4f72-a262-e0a23b0e99e9 |      | fa:16:3e:65:52:29 | ip_address='192.168.254.1', subnet_id='49eaed11-788e-41dd-8823-12964c9f90e5' | ACTIVE |
| 32be354d-010e-4182-b72e-bfa587732aa7 |      | fa:16:3e:2c:12:8c | ip_address='192.168.255.1', subnet_id='2bb680e4-2da0-4f51-9b52-ad41e006ad43' | ACTIVE |
| 35c5e71d-7187-4fbe-94e9-cf4225df5ef7 |      | fa:16:3e:91:a5:86 | ip_address='172.16.99.10', subnet_id='e7210532-3d56-4eaf-9826-0711756ad3f4'  | ACTIVE |
| 53a086d6-80af-4956-8705-4cd54129022d |      | fa:16:3e:b7:fd:e7 | ip_address='172.16.99.2', subnet_id='e7210532-3d56-4eaf-9826-0711756ad3f4'   | ACTIVE |
| 61b803dc-36ad-4949-aa80-0b4b73b0a69d |      | fa:16:3e:d9:b1:92 | ip_address='192.168.254.6', subnet_id='49eaed11-788e-41dd-8823-12964c9f90e5' | ACTIVE |
| bc7c49fb-1acc-4af4-b4bc-5485f6962aea |      | fa:16:3e:fd:60:72 | ip_address='192.168.255.2', subnet_id='2bb680e4-2da0-4f51-9b52-ad41e006ad43' | ACTIVE |
| e770a957-be50-46c1-b90a-ec2aa90da38b |      | fa:16:3e:40:6a:d1 | ip_address='192.168.255.5', subnet_id='2bb680e4-2da0-4f51-9b52-ad41e006ad43' | ACTIVE |
| e9566f29-0f7a-4cdb-81d4-237f412b2cfd |      | fa:16:3e:af:21:1a | ip_address='192.168.254.2', subnet_id='49eaed11-788e-41dd-8823-12964c9f90e5' | ACTIVE |
+--------------------------------------+------+-------------------+------------------------------------------------------------------------------+--------+
```

Step 2 - After getting the port ID from the above command, execute the `openstack port show <ID>` command to see the current configuration for the port
```
$ openstack port show 32be354d-010e-4182-b72e-bfa587732aa7
+-----------------------+------------------------------------------------------------------------------+
| Field                 | Value                                                                        |
+-----------------------+------------------------------------------------------------------------------+
| admin_state_up        | UP                                                                           |
| allowed_address_pairs |                                                                              |
| binding_host_id       | None                                                                         |
| binding_profile       | None                                                                         |
| binding_vif_details   | None                                                                         |
| binding_vif_type      | None                                                                         |
| binding_vnic_type     | normal                                                                       |
| created_at            | 2018-01-25T18:52:38Z                                                         |
| data_plane_status     | None                                                                         |
| description           |                                                                              |
| device_id             | 12a00eb4-5198-4fde-933c-4c6d1d047cda                                         |
| device_owner          | compute:nova                                                                 |
| dns_assignment        | None                                                                         |
| dns_name              | None                                                                         |
| extra_dhcp_opts       |                                                                              |
| fixed_ips             | ip_address='192.168.255.1', subnet_id='2bb680e4-2da0-4f51-9b52-ad41e006ad43' |
| id                    | 32be354d-010e-4182-b72e-bfa587732aa7                                         |
| ip_address            | None                                                                         |
| mac_address           | fa:16:3e:2c:12:8c                                                            |
| name                  |                                                                              |
| network_id            | 2f25227b-80b0-4f31-b11b-9b2d8066127c                                         |
| option_name           | None                                                                         |
| option_value          | None                                                                         |
| port_security_enabled | True                                                                         |
| project_id            | 1e2b5c63d1f14091b237acf064cc9db6                                             |
| qos_policy_id         | None                                                                         |
| revision_number       | 6                                                                            |
| security_group_ids    | b0ab9379-bb17-432f-be23-c06fd765f719                                         |
| status                | ACTIVE                                                                       |
| subnet_id             | None                                                                         |
| tags                  |                                                                              |
| trunk_details         | None                                                                         |
| updated_at            | 2018-01-25T18:52:44Z                                                         |
+-----------------------+------------------------------------------------------------------------------+
```

Step 3 - Set the allowed address pairs to 0.0.0.0/0 for the port using the `openstack port set` command
```
$ openstack port set --allowed-address ip-address=0.0.0.0/0 32be354d-010e-4182-b72e-bfa587732aa7
```

Step 4 - Check again using the `openstack port show` command
```
$ openstack port show 32be354d-010e-4182-b72e-bfa587732aa7
+-----------------------+------------------------------------------------------------------------------+
| Field                 | Value                                                                        |
+-----------------------+------------------------------------------------------------------------------+
| admin_state_up        | UP                                                                           |
| allowed_address_pairs | ip_address='0.0.0.0/0', mac_address='fa:16:3e:2c:12:8c'                      |
| binding_host_id       | None                                                                         |
| binding_profile       | None                                                                         |
| binding_vif_details   | None                                                                         |
| binding_vif_type      | None                                                                         |
| binding_vnic_type     | normal                                                                       |
| created_at            | 2018-01-25T18:52:38Z                                                         |
| data_plane_status     | None                                                                         |
| description           |                                                                              |
| device_id             | 12a00eb4-5198-4fde-933c-4c6d1d047cda                                         |
| device_owner          | compute:nova                                                                 |
| dns_assignment        | None                                                                         |
| dns_name              | None                                                                         |
| extra_dhcp_opts       |                                                                              |
| fixed_ips             | ip_address='192.168.255.1', subnet_id='2bb680e4-2da0-4f51-9b52-ad41e006ad43' |
| id                    | 32be354d-010e-4182-b72e-bfa587732aa7                                         |
| ip_address            | None                                                                         |
| mac_address           | fa:16:3e:2c:12:8c                                                            |
| name                  |                                                                              |
| network_id            | 2f25227b-80b0-4f31-b11b-9b2d8066127c                                         |
| option_name           | None                                                                         |
| option_value          | None                                                                         |
| port_security_enabled | True                                                                         |
| project_id            | 1e2b5c63d1f14091b237acf064cc9db6                                             |
| qos_policy_id         | None                                                                         |
| revision_number       | 8                                                                            |
| security_group_ids    | b0ab9379-bb17-432f-be23-c06fd765f719                                         |
| status                | ACTIVE                                                                       |
| subnet_id             | None                                                                         |
| tags                  |                                                                              |
| trunk_details         | None                                                                         |
| updated_at            | 2018-01-28T17:06:47Z                                                         |
+-----------------------+------------------------------------------------------------------------------+
```

*Note: Don't forget to repeat for the other two ports*

## Return Routes for OpenStack Router
After setting the allowed address pairs, you will notice that you are able to ping the tenant101-internet IPv4 address of the CSR1kv, however you are not able to ping the IPv4 address of tenant101-internet's default gateway (which is OpenStack's router), why ?

If you execute the following command you will notice that the line for routes is blank:
```
$ openstack router show tenant101-router
+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                   | Value                                                                                                                                                                                    |
+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| admin_state_up          | UP                                                                                                                                                                                       |
| availability_zone_hints |                                                                                                                                                                                          |
| availability_zones      | nova                                                                                                                                                                                     |
| created_at              | 2018-01-22T00:30:30Z                                                                                                                                                                     |
| description             |                                                                                                                                                                                          |
| distributed             | False                                                                                                                                                                                    |
| external_gateway_info   | {"network_id": "06ca5380-84eb-46b1-b0db-8fa038f72998", "enable_snat": true, "external_fixed_ips": [{"subnet_id": "9b34213c-eff1-4008-a387-d08ee49b5ee0", "ip_address": "172.31.57.11"}]} |
| flavor_id               | None                                                                                                                                                                                     |
| ha                      | False                                                                                                                                                                                    |
| id                      | 47ccc9d6-1544-4b13-a8c3-d7ce48eb1899                                                                                                                                                     |
| name                    | tenant101-router                                                                                                                                                                          |
| project_id              | 1e2b5c63d1f14091b237acf064cc9db6                                                                                                                                                         |
| revision_number         | 8                                                                                                                                                                                        |
| routes                  |                                                                                                                                                                                          |
| status                  | ACTIVE                                                                                                                                                                                   |
| tags                    |                                                                                                                                                                                          |
| updated_at              | 2018-01-29T10:36:26Z                                                                                                                                                                     |
+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

OpenStack's router does not know where 192.168.255.0/24 should be routed to, thus it will send traffic destined to 192.168.255.0/24 to its default route which is the internet (if you are curious on how to figure out what routes the OpenStack router has, go to [Neutron Intensive Tasks](#neutron-intensive-tasks))

*Hint: if you don't want to jump ahead to that section, you can execute the following the command to check it:*
```
sudo ip netns exec qrouter-`openstack router list | grep -e "tenant.*router" | awk '{ print $2 }'` ip route
```

In order to the the route you can execute the following command:
```
$ openstack router set --route destination=192.168.255.0/24,gateway=192.168.254.10 tenant101-router
$ openstack router show tenant101-router
+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                   | Value                                                                                                                                                                                    |
+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| admin_state_up          | UP                                                                                                                                                                                       |
| availability_zone_hints |                                                                                                                                                                                          |
| availability_zones      | nova                                                                                                                                                                                     |
| created_at              | 2018-01-22T00:30:30Z                                                                                                                                                                     |
| description             |                                                                                                                                                                                          |
| distributed             | False                                                                                                                                                                                    |
| external_gateway_info   | {"network_id": "06ca5380-84eb-46b1-b0db-8fa038f72998", "enable_snat": true, "external_fixed_ips": [{"subnet_id": "9b34213c-eff1-4008-a387-d08ee49b5ee0", "ip_address": "172.31.57.11"}]} |
| flavor_id               | None                                                                                                                                                                                     |
| ha                      | False                                                                                                                                                                                    |
| id                      | 47ccc9d6-1544-4b13-a8c3-d7ce48eb1899                                                                                                                                                     |
| name                    | tenant101-router                                                                                                                                                                          |
| project_id              | 1e2b5c63d1f14091b237acf064cc9db6                                                                                                                                                         |
| revision_number         | 7                                                                                                                                                                                        |
| routes                  | destination='192.168.255.0/24', gateway='192.168.254.6'                                                                                                                                  |
| status                  | ACTIVE                                                                                                                                                                                   |
| tags                    |                                                                                                                                                                                          |
| updated_at              | 2018-01-29T10:08:36Z                                                                                                                                                                     |
+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

*Review the section and discuss if you have any questions or comments.*

---

# Neutron Intensive Tasks
*Estimated time to complete: 30 min.*

The project code-name for networking services is Neutron. OpenStack networking handles the creation and management of virtual networking infrastructure, including networks, switches, subnets, and routers.

Several linux and Openstack components are involved to make the neutron networking work. We will see 3 components in this section.
* Linux bridge
	* traffic filtering, shaping, and security
* OpenVswitch
	* Openstack L2 agent.
	* Multilayer L2 switch.
* Openstack L3 agent router
	* Openstack L3 agent.

The goal of this section is to show networking in the lab cloud. The tasks in this section will help you navigate the path from your virtual machine (VM) to External network.

* In this section, you need to execute the commands from the host that is hosting your VM, tenant-pc. So, the first step would be to find the host that is running your  VM.
* Please note that we are using Openstack’s L3 agent router to route traffic to Internet. And, this router is hosted on the Network-node, which is 172.31.56.216 (this is also running Controller and a Compute functions).

## Topology
![neutron-1](https://github.com/userlerueda/LTRCLD-1451/blob/master/images/neutron-1.png)

## Packet Path

In this below example diagram, our VM is hosted on a separate (other than S6 Controller) compute node. If your VM is on S6 node, traffic need not cross vxlan tunnel. Here the VM is CSR1Kv router.
![neutron-3](https://github.com/userlerueda/LTRCLD-1451/blob/master/images/neutron-2.png)

Red dotted line represents path from CSR1Kv to Internet. If you notice, traffic goes to Network node and reaches Internet via the openstack-router. Here, Controller node is functioning as Network node.

Including Network node, there are 6 nodes in our setup. br-tun bridge would have 5 VXLAN-tunnel interfaces to going to br-tun bridges on the other nodes.

The tasks below will navigate packet path, from CSR1Kv to Internet. This diagram may be needed for reference while you are working on the steps below. You may want to open this [diagram](https://github.com/userlerueda/LTRCLD-1451/blob/master/images/neutron-3.png) in a new tab (right click and "open in a new tab").

## Packet Tracing Tasks

Execute the below tasks:

* Generate traffic from tenantxxx-pc to Internet
	* Login to Controller node: `ssh tenant101@172.31.56.216`
	* Load Openstack environment variables: `source keystonerc_user101`
	* Find your router's ID: `openstack router list | grep <tenant101>`
	* Find your router name space ID: `ip netns | grep <router-id>`
	* Find IP address of you PC VM: `openstack server list | grep <tenant101-pc>`
	* Login into your PC VM: In this step, we ssh into your VM from your router. You need to enter sudo password (cisco.123) and then cirros password (gocubsgo): `sudo ip netns exec <router namespace id> ssh cirros@<ip addr of your PC>`
	* From cirros:$ `ping 8.8.8.8`
	* Let pings go. We will be tracing these packets in the following sections. Do not close this ssh window.

Example:
```
GNAGANAB-M-J0A4:~ gnaganab$ ssh tenant101@172.31.56.216
tenant101@172.31.56.216's password:
Last login: Tue Jan 30 08:49:58 2018 from 172.31.56.35
[tenant101@PSL-DMZ-C-S6 ~]$ source keystonerc_admin101
[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]$ openstack router list | grep tenant101
| 47ccc9d6-1544-4b13-a8c3-d7ce48eb1899 | tenant101-router  | ACTIVE | UP    | False       | False | 1e2b5c63d1f14091b237acf064cc9db6 |
[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]$ ip netns | grep 47ccc9d6-1544-4b13-a8c3-d7ce48eb1899
qrouter-47ccc9d6-1544-4b13-a8c3-d7ce48eb1899
[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]$ openstack server list | grep tenant101-pc
| 9de2e138-9d5c-49c4-8d4d-b0a981fda859 | tenant101-pc     | ACTIVE | tenant101-internal=192.168.255.5                                                                                 | tenant101-cirros-0.4.0-x86_64 | tenant101-m1.nano      |
[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]$ sudo ip netns exec qrouter-47ccc9d6-1544-4b13-a8c3-d7ce48eb1899 ssh cirros@192.168.255.5
[sudo] password for tenant101:
The authenticity of host '192.168.255.5 (192.168.255.5)' can't be established.
ECDSA key fingerprint is SHA256:I6Z4pRgJdnXcm/G5z0ZfL8e5mTVXnEYBcg59nuf2wuE.
ECDSA key fingerprint is MD5:dd:bc:1a:db:20:90:60:22:14:03:d6:9e:aa:ff:de:e1.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.255.5' (ECDSA) to the list of known hosts.
cirros@192.168.255.5's password:
$  ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: seq=0 ttl=58 time=10.653 ms
64 bytes from 8.8.8.8: seq=1 ttl=58 time=10.587 ms
```

* Find port-ID of your cirros VM
	* Open a new ssh window. `ssh tenant101@172.31.56.216`
	* Load Openstack **member** environment variables: `source keystonerc_user101`
	* Find IP address of your cirros VM: `openstack server list | grep pc`
	* Find port id. Note this down.: `openstack port list | grep <ip address of your cirros VM>`

Example:
```
GNAGANAB-M-J0A4:~ gnaganab$ ssh tenant101@172.31.56.216
tenant101@172.31.56.216's password:
Last login: Tue Jan 30 10:43:45 2018 from 172.31.56.35
[tenant101@PSL-DMZ-C-S6 ~]$ source keystonerc_user101
[tenant101@PSL-DMZ-C-S6 ~( user101@tenant101 )]$ openstack server list | grep pc
| 9de2e138-9d5c-49c4-8d4d-b0a981fda859 | tenant101-pc     | ACTIVE | tenant101-internal=192.168.255.5                                                                                 | tenant101-cirros-0.4.0-x86_64 | tenant101-m1.nano      |
[tenant101@PSL-DMZ-C-S6 ~( user101@tenant101 )]$ openstack port list | grep 192.168.255.5
| e770a957-be50-46c1-b90a-ec2aa90da38b |      | fa:16:3e:40:6a:d1 | ip_address='192.168.255.5', subnet_id='2bb680e4-2da0-4f51-9b52-ad41e006ad43'  | ACTIVE |
[tenant101@PSL-DMZ-C-S6 ~( user101@tenant101 )]$
```

* SSH into the compute node of interest
	* Open a new ssh window. `ssh tenant101@172.31.56.216`
	* Load Openstack admin environment variables: `source keystonerc_admin101`
	* Find Compute node that hosts your cirros VM.
		* `openstack server list | grep pc`
		* `openstack server show <tenant101-pc>` (hostname is in the field, "OS-EXT-SRV-ATTR:host")
	* SSH into the compute node: `ssh root@<hostname from above output>` (No need to enter root password since ssh key is copied already)

Example:
```
GNAGANAB-M-J0A4:~ gnaganab$ ssh tenant101@172.31.56.216
tenant101@172.31.56.216's password:
Last login: Tue Jan 30 10:18:23 2018 from 172.31.56.35
[tenant101@PSL-DMZ-C-S6 ~]$ source keystonerc_admin101
[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]$ openstack server list | grep pc
| 9de2e138-9d5c-49c4-8d4d-b0a981fda859 | tenant101-pc     | ACTIVE | tenant101-internal=192.168.255.5                                                                                 | tenant101-cirros-0.4.0-x86_64 | tenant101-m1.nano      |
[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]$ openstack server show tenant101-pc
+-------------------------------------+---------------------------------------------------------------------+
| Field                               | Value                                                               |
+-------------------------------------+---------------------------------------------------------------------+
| OS-DCF:diskConfig                   | AUTO                                                                |
| OS-EXT-AZ:availability_zone         | nova                                                                |
| OS-EXT-SRV-ATTR:host                | PSL-DMZ-C-S3 <<<this one                                            |
| OS-EXT-SRV-ATTR:hypervisor_hostname | compute-3                                                           |
| OS-EXT-SRV-ATTR:instance_name       | instance-00000024                                                   |
| OS-EXT-STS:power_state              | Running                                                             |
| OS-EXT-STS:task_state               | None                                                                |
| OS-EXT-STS:vm_state                 | active                                                              |
| OS-SRV-USG:launched_at              | 2018-01-28T16:16:10.000000                                          |
| OS-SRV-USG:terminated_at            | None                                                                |
| accessIPv4                          |                                                                     |
| accessIPv6                          |                                                                     |
| addresses                           | tenant101-internal=192.168.255.5                                     |
| config_drive                        |                                                                     |
| created                             | 2018-01-28T16:15:58Z                                                |
| flavor                              | tenant101-m1.nano (8a116bb5-25f0-492d-8712-56b45fc8a8d9)             |
| hostId                              | 6f5bfa46838f81f07379af4460b1caa965c5282ea76d83695d07ba2a            |
| id                                  | 9de2e138-9d5c-49c4-8d4d-b0a981fda859                                |
| image                               | tenant101-cirros-0.4.0-x86_64 (aaac0de7-2248-46f3-a283-775891ab888e) |
| key_name                            | None                                                                |
| name                                | tenant101-pc                                                         |
| progress                            | 0                                                                   |
| project_id                          | 1e2b5c63d1f14091b237acf064cc9db6                                    |
| properties                          |                                                                     |
| security_groups                     | name='tenant101-allow_ssh'                                           |
|                                     | name='tenant101-allow_icmp'                                          |
|                                     | name='default'                                                      |
| status                              | ACTIVE                                                              |
| updated                             | 2018-01-28T16:16:10Z                                                |
| user_id                             | 61a72633cdf0432b8c6c69c3bc444e70                                    |
| volumes_attached                    |                                                                     |
+-------------------------------------+---------------------------------------------------------------------+
[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]$
[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]$ ssh root@PSL-DMZ-C-S3
[sudo] password for tenant101:
Last failed login: Tue Jan 30 10:29:45 EST 2018 from controller on ssh:notty
There were 6 failed login attempts since the last successful login.
Last login: Tue Jan 30 10:18:58 2018 from controller
[root@PSL-DMZ-C-S3 ~]#

```

* Trace packets on Linux Q bridge
	* Find the associated interface on the q bridge. Refer to the 2nd neutron diagram for reference.
		* `brctl show`
		* `brctl show  | grep <port id of cirros VM. Use first 8 digits>`
	* Last column lists interfaces on the bridge. Find the interface with prefix, "tap"
	* Confirm that the Compute node has that interface
		* `ifconfig tap<first10digits-of-port>`
	* Monitor icmp packets: # `tcpdump -i <tap interface> icmp`
	* Tcpdump should display the ping packets. If you don't see them, make sure your ping packets are still going on the other window.

Example:
```
[root@PSL-DMZ-C-S3 ~]# brctl show
bridge name	bridge id		STP enabled	interfaces
qbr3f684264-18		8000.d63e3eaad629	no		qvb3f684264-18
							tap3f684264-18
qbre770a957-be		8000.16a15552c0b6	no		qvbe770a957-be
							tape770a957-be
[root@PSL-DMZ-C-S3 ~]# brctl show  | grep tape770a957-be
							tape770a957-be
[root@PSL-DMZ-C-S3 ~]# ifconfig tape770a957-be
tape770a957-be: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
        inet6 fe80::fc16:3eff:fe40:6ad1  prefixlen 64  scopeid 0x20<link>
        ether fe:16:3e:40:6a:d1  txqueuelen 1000  (Ethernet)
        RX packets 1000  bytes 99345 (97.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1352  bytes 127404 (124.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
[root@PSL-DMZ-C-S3 ~]# tcpdump -i tape770a957-be icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on tape770a957-be, link-type EN10MB (Ethernet), capture size 262144 bytes
```

* Trace packets on OVS bridge
	* Refer to neutron-2 diagram
	* `ovs-vsctl list-br`
	* `ovs-vsctl list-ports br-int | grep <first 8 digits of cirros port-id>`
	* Verify if the interface exists. `ifconfig qvo<10digits-of-port>`
	* Monitor packets. `tcpdump -i <interface-id> icmp`
	* Tcpdump should display the ping packets. If you don't see them, make sure your ping packets are still going on the other window.

Example:
```
[root@PSL-DMZ-C-S3 ~]# ovs-vsctl list-br
br-int
br-prov
br-tun
[root@PSL-DMZ-C-S3 ~]# ovs-vsctl list-ports br-int | grep e770a957-be
qvoe770a957-be
[root@PSL-DMZ-C-S3 ~]# ifconfig qvoe770a957-be
qvoe770a957-be: flags=4419<UP,BROADCAST,RUNNING,PROMISC,MULTICAST>  mtu 1450
        inet6 fe80::44e2:65ff:fe96:c249  prefixlen 64  scopeid 0x20<link>
        ether 46:e2:65:96:c2:49  txqueuelen 1000  (Ethernet)
        RX packets 1010  bytes 100377 (98.0 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1391  bytes 132480 (129.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

[root@PSL-DMZ-C-S3 ~]# tcpdump -i qvoe770a957-be icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on qvoe770a957-be, link-type EN10MB (Ethernet), capture size 262144 bytes
```

* Monitor packets on vxlan tunnel interface
	* Refer to neutron-2 diagram
	* Important: This is applicable only if the Compute node is not same as the Controller node (PSL-DMZ-C-S6). If your VM is running on PSL-DMZ-C-S6, please skip this subsection. As you can see in the topology diagram, vxlan tunnel interface is used for packets going from VM's on S1 though S5 Compute nodes to Internet.
	* `ifconfig enp14s0f0`
	* Monitor packets. `tcpdump -i enp14s0f0`
	* Tcpdump should display the ping packets. If you don't see them, make sure your ping packets are still going on the other window.

Example:
```
[root@PSL-DMZ-C-S3 ~]# ifconfig enp14s0f0
enp14s0f0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.254.213  netmask 255.255.255.0  broadcast 192.168.254.255
        inet6 fe80::92e2:baff:feca:e804  prefixlen 64  scopeid 0x20<link>
        ether 90:e2:ba:ca:e8:04  txqueuelen 1000  (Ethernet)
        RX packets 867939  bytes 70984049 (67.6 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 60382  bytes 12711693 (12.1 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

[root@PSL-DMZ-C-S3 ~]# tcpdump -i enp14s0f0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enp14s0f0, link-type EN10MB (Ethernet), capture size 262144 bytes
```

* Monitor packets on Openstack router
	* Be on the Controller node, IP=172.31.56.216, hostname=PSL-DMZ-C-S6. You may simply exit from the current ssh session to go back to Controller node. $ `exit`
	* source keystonerc_user101
	* openstack router list
	* Find your router name space ID. $ ` ip netns | grep `openstack router list | awk '{print $2}' | grep -v ID` `
	* Find interface facing cirros VM. `sudo ip netns exec <qrouter-router-id> ip addr`
	* Monitor packets on the openstack rotuer: `sudo ip netns exec <qrouter-router-id> tcpdump -i <interface-id> icmp`
	* Tcpdump should display the ping packets. If you don't see them, make sure your ping packets are still going on the other window.

Example:
```
[root@PSL-DMZ-C-S3 ~]# exit
logout
Connection to psl-dmz-c-s3 closed.
[tenant101@PSL-DMZ-C-S6 ~]$
[tenant101@PSL-DMZ-C-S6 ~]$ source keystonerc_user101
[tenant101@PSL-DMZ-C-S6 ~( user101@tenant101 )]$ openstack router list
+--------------------------------------+-----------------+--------+-------+-------------+-------+----------------------------------+
| ID                                   | Name            | Status | State | Distributed | HA    | Project                          |
+--------------------------------------+-----------------+--------+-------+-------------+-------+----------------------------------+
| 47ccc9d6-1544-4b13-a8c3-d7ce48eb1899 | tenant101-router | ACTIVE | UP    | False       | False | 1e2b5c63d1f14091b237acf064cc9db6 |
+--------------------------------------+-----------------+--------+-------+-------------+-------+----------------------------------+
[tenant101@PSL-DMZ-C-S6 ~( user101@tenant101 )]$
[tenant101@PSL-DMZ-C-S6 ~( user101@tenant101 )]$ ip netns | grep `openstack router list | awk '{print $2}' | grep -v ID`
qrouter-47ccc9d6-1544-4b13-a8c3-d7ce48eb1899
[tenant101@PSL-DMZ-C-S6 ~( user101@tenant101 )]$ sudo ip netns exec qrouter-47ccc9d6-1544-4b13-a8c3-d7ce48eb1899 ip addr
[sudo] password for tenant101:
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
34: qg-e77c253c-8b: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN qlen 1000
    link/ether fa:16:3e:de:9c:df brd ff:ff:ff:ff:ff:ff
    inet 172.31.57.11/24 brd 172.31.57.255 scope global qg-e77c253c-8b
       valid_lft forever preferred_lft forever
    inet 172.31.57.22/32 brd 172.31.57.22 scope global qg-e77c253c-8b
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fede:9cdf/64 scope link
       valid_lft forever preferred_lft forever
35: qr-325e6e70-ec: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN qlen 1000
    link/ether fa:16:3e:65:52:29 brd ff:ff:ff:ff:ff:ff
    inet 192.168.254.1/24 brd 192.168.254.255 scope global qr-325e6e70-ec
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fe65:5229/64 scope link
       valid_lft forever preferred_lft forever
[tenant101@PSL-DMZ-C-S6 ~( user101@tenant101 )]$
[tenant101@PSL-DMZ-C-S6 ~( user101@tenant101 )]$ sudo ip netns exec qrouter-47ccc9d6-1544-4b13-a8c3-d7ce48eb1899 tcpdump -i qr-325e6e70-ec icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on qr-325e6e70-ec, link-type EN10MB (Ethernet), capture size 262144 bytes

```

*Review the section and discuss if you have any questions or comments.*

---

# OpenStack Review Tasks
*Estimated time to complete: 15 min.*

In this concluding section, you will try to get an overall view of the Openstack cloud that you just worked on. Try to make sense of the output of each command. These are some commonly used monitoring commands. Not every command and output may have a direct connection to the work that you did so far. The goal is to get an overall idea, not necessarily a detailed one.

Please note that a typical production NFV system or Openstack cloud includes components such as exclusive storage, high performance network connectivity with PCIe or SR-IOv, OSS/BSS system, VNF management system, and Orchestration systems. In this lab, we have Openstack alone, which makes up ETSI model’s Virtual Infrastructure Manager (VIM).

* login into Controller node: `ssh tenant101@172.31.56.216`
* Load environment parameters for Openstack access:$ `source keystonerc_admin101`

* Cloud overview
	* `openstack-status`
	* `openstack-service list`
	* `openstack service list`
	* `openstack hypervisor list`
	* `openstack hypervisor stats show`
	* `openstack host list`
	* `openstack host show <host name>`

* Compute overview
	* `openstack compute service list`
		* note that there are 6 Computes. Node PSL-DMZ-C-S6 is hosting Controller, Network, and Compute functions.
	* `openstack usage list`
	* `openstack host list`
	* `openstack host show <host name>`
	* `openstack flavor list`
	* `openstack image list`
	* `openstack server list --all-projects`
	* `openstack quota show <project name>`

* Network overview
	* `openstack network list`
	* `openstack network show <net name or ID>`
	* `openstack subnet list`
	* `openstack subnet show <subnet name or ID>`
	* `openstack router list`
	* `openstack network agent list`
	* `openstack port list`
	* `sudo ovs-vsctl show`
	* `sudo ovs-vsctl list-br`

* Identity overview
	* `openstack project list`
	* `openstack role list`
	* `openstack user list`

* Miscellaneous
	* `openstack command list`
	* `openstack command list --group openstack.compute.v2`
	* `openstack command list --group openstack.network.v2`
	* `brctl show`
	* `ip netns`
	* `openstack network list | awk '{ print $2 }'`
		* print only second column of the output, "openstack network list".
	* `openstack network list | grep external | awk '{ print $2 }'`
		* print network-id of the network named, "external"
Example:
```
[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]$ openstack network list | awk '{ print $2 }'

ID

04eea3ef-4bd0-4a53-bb41-9ee306fce37f
06ca5380-84eb-46b1-b0db-8fa038f72998
2c3d2f04-41ed-4c1a-956d-e57f61758f1e
2f25227b-80b0-4f31-b11b-9b2d8066127c
5da13369-b2ea-422b-9b9d-e3c93ec1acdb
631e32e7-8e1f-42fb-a927-ec1d7dc31293
90c70132-0ea7-4362-8ab4-aff50986d012

[tenant101@PSL-DMZ-C-S6 ~( admin101@tenant101 )]$ openstack network list | grep external | awk '{ print $2 }'
06ca5380-84eb-46b1-b0db-8fa038f72998
```

*Review the section and discuss if you have any questions or comments.*

---

# Resources
## Openstack Neutron VOD
- [Cisco Webinar video](https://learningnetwork.cisco.com/docs/DOC-30375)
- cisco.com account needed to access this link.
- Click "Access the recording" and accept Flash as reader.
## Cisco Devnet
- OpenStack on your Laptop [openstack-on-laptop](https://learninglabs.cisco.com/lab/openstack-install/step/1)
## Openstack lab video
- [lab video](https://www.openstack.org/videos/austin-2016/hands-on-lab-test-drive-your-openstack-network)
- Covers nova features using Horizon navigation.
## Video on Neutron
- Neutron Network Know-How: A Hands-On Workshop for Solving Neutron Nightmares [neutron-video](https://www.youtube.com/watch?v=B17qcaSglHA)
## Openstack solutions at cisco
- [Openstack@Cisco](https://www.cisco.com/c/en/us/solutions/data-center-virtualization/openstack-at-cisco/index.html)

---

<p align="center">
	<b>End of session</b>
</p>

---
