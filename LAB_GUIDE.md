<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Logistics](#logistics)
- [Introduction to OpenStack](#introduction-to-openstack)
- [OpenStack Installation](#openstack-installation)
- [Lecture](#lecture)
- [Lab Environment Walkthrough](#lab-environment-walkthrough)
	- [HW topology](#hw-topology)
	- [Layer 3 Topology](#layer-3-topology)
	- [Connectivity](#connectivity)
	- [Testing VPN Lab Connectivity](#testing-vpn-lab-connectivity)
	- [Browse overall OpenStack cloud (some openstack CLI (host list etc), access computes etc)](#browse-overall-openstack-cloud-some-openstack-cli-host-list-etc-access-computes-etc)
- [Admin Tasks](#admin-tasks)
	- [Scenario (1 minute)](#scenario-1-minute)
	- [Create Flavors (5 minutes)](#create-flavors-5-minutes)
	- [Create Networks and Subnets (5 minutes)](#create-networks-and-subnets-5-minutes)
	- [Create images (5 minutes)](#create-images-5-minutes)
	- [Create Floating IP Pool (5 minutes)](#create-floating-ip-pool-5-minutes)
- [Tenant Tasks](#tenant-tasks)
	- [Create Networks and Subnets (5 minutes)](#create-networks-and-subnets-5-minutes)
	- [Create Internet Network and Subnet (3 minutes)](#create-internet-network-and-subnet-3-minutes)
	- [Create Internal Network and Subnet (2 minutes)](#create-internal-network-and-subnet-2-minutes)
	- [Create OpenStack Router (5 minutes)](#create-openstack-router-5-minutes)
		- [Attach router to provider network](#attach-router-to-provider-network)
	- [Launch Instances (10 minutes)](#launch-instances-10-minutes)
		- [Security Groups](#security-groups)
		- [Launch CSR1Kv Instance](#launch-csr1kv-instance)
		- [Launch CirrOS Instance](#launch-cirros-instance)
	- [Allowed Address Pairs](#allowed-address-pairs)
		- [Required neutron customizations](#required-neutron-customizations)
		- [Remote ssh access and verification tasks](#remote-ssh-access-and-verification-tasks)
		- [Openstack review tasks (infra, neutron, nova focus)](#openstack-review-tasks-infra-neutron-nova-focus)
		- [Openstack API features](#openstack-api-features)
- [Openstack orchestration](#openstack-orchestration)
	- [HEAT templates?](#heat-templates)
- [Neutron Intensive Tasks](#neutron-intensive-tasks)
- [OpenStack Review Tasks](#openstack-review-tasks)
- [Resources](#resources)
	- [Cisco DEvnet: OpenStack on your Laptop https://learninglabs.cisco.com/lab/openstack-install/step/1](#cisco-devnet-openstack-on-your-laptop-httpslearninglabsciscocomlabopenstack-installstep1)

---

# Logistics

## Welcome
* Speaker intro: Luis Rueda, Gopal Naganaboyina
* What are your expectations? Any specific areas to focus?
* We tried to give emphasis to networking aspect.

## Time management
* There are 10 Sections, with an estimated completion time of 3 hr. 30 min. !!![edit]
* Every section has estimated time to complete. This is an estimate only. Please feel free to spend as much time as you like.
* Please plan a 5 min break, as needed, around 2 hr. mark or after completing sectio-X !!![comeback to edit]

## Questions
* Questions are most welcome. We **request** you to ask questions and make the session interactive.
* Self exploration is fun. At the end of each section, take a few minutes to review and ask questions if you have any.

## Openstack installation
* Openstack installation is not included in this session to make efficient use of time.
* If installation is successful, there is not much to learn. If not successful, there won't be enough time within this session to troubleshoot.
* For this lab, we used Packstack installer on CentOS7.4. This is a multi-node installation, with one Controller and 6 Compute nodes. One biggest problem we encountered was copy-time-out.

## Join the discussion at Cisco Spark
A spark room has been created and will be kept for X days after the session. Please share any questions, comments or feedback.
* Go to [spark](http://cs.co/ciscolivebot#LTRCLD-1451) and add your email address
* Select Spark installed/not-installed based on whether your device (phone/laptop) has Spark or not.

---

# Introduction to Openstack

Refer to [slides](./pdfs/Introduction_to_OpenStack_v1.pdf) presented.

---

# Credentials

You will be given a paper copy of IP addresses, username, password info.

---

# Lab Connectivity
* Estimated time to complete: 15 min.

All the tasks in this guide can be done using OpenStack CLI or OpenStack Horizon's Dashboard, the examples will be using either one of them and it is up to the student to explore the different ways of doing it using the alternate method.

*Note: It is also possible to do things using other methods such as API or high level python libraries.*

Please note that a typical production NFV system or Openstack cloud includes components such as exclusive storage, DPDK network connectivity with PCIe or SR-IOv, OSS/BSS system, VNF management system, and Orchestration systems. In this lab, we have Openstack alone, which makes up ETSI model’s Virtual Infrastructure Manager (VIM).

The lab is built with 7 Cisco UCS C240 servers. The lab is behind a VPN server. To access the lab, you need to VPN into the VPN server. The VPN server and the lab are in USA and the access to VPN server is over Internet.

## HW topology

Access to the lab is over VPN tunnel. When you create the tunnel, VPN server will advertise a few routes to your laptop.

![Physical Toplogy](./images/lab_walkthrough_hw_topology_00.png)

## Layer 3 Topology

Openstack Controller has connectivity to external-VLAN but not any Computes. Your access to Openstack cloud, which include Computes is through Controller.

There are a few other VLANs such as management but their details are not shown here.

Provider data center services and customer’s hypothetical CPE connections are emulated from a dedicated server, marked in the below topology as “provider DC cloud”. Other than hosting some services, this server is not playing any other role in this session.

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
	- If ping succeeds, open the following link in a new tab: [http://172.31.56.216](http://172.31.56.216)
	- If ping fails, check if you have 1) successfully VPN into the lab VPN-server and 2) you have a route to 172.31.56.0/24. Windows command to list route table: `route print`

*Review the section and discuss if you have any questions or comments.*

---

# Openstack cloud high level view
*Estimated time to complete: 15 min.*

Use command line interface (CLI) and Horizon dashboard and try to get a overall view of the Openstack cloud that we are going to use.

## Command line interface (CLI)

* login into Controller node: `ssh tenantXXX@172.31.56.216`
	* Use **putty** app provided in your lab laptop
	* IP address: `172.31.56.216`
	* username: `tenantXXX`
	* password: `cisco.123`
* Load environment parameters for Openstack access: `$ source keystonerc_adminXXX`
* Try the below commands:
	* `openstack-status`
	* `openstack-service list`
	* `openstack-service status`
	* `openstack hypervisor list`
	* `openstack hypervisor stats show`
	* `openstack usage list`

## Horizon dashboard

* Login into Horizon dashboard using the credentials below:
	* username: `adminXXX`
	* password: `cisco.123`
* On the left pane, go to: "Admin"/"Overview"
	* Observe VCPUs, RAM, etc. resource usage.
* On the left pane, go to: "Admin"/"Compute"/"Hypervisors"
	* On the "Hypervisor" tab, observe total and used resources.
	* On the "Compute host" tab, observe "Status" of different hosts.

*Review the section and discuss if you have any questions or comments.*

---

# Admin Tasks
*Estimated time to complete: 30 min.*

## Scenario

In this section, you would assume the role of an administrator of an OpenStack cloud. The goal is to create all the necessary elements for your users to be able to later create a virtual machine and make some basic verifications. This exercise exposes typical OpenStack admin environment.

Cloud owner name is Great-Cloud. All the participants are Great-Cloud’s administrators.

The following diagram depicts the topology:
![Topolgy](./images/admin_tasks_topology_01.png) TODO: Gopal. Edit the ppt to add the image

## Source keystone_adminrc file

For all the commands that are executed using OpenStack CLI the first thing that need to be done is to source all the necessary variables that will allow us to authenticate with OpenStack.

```
$ source ~/keystonerc_adminXXX
```

## Create Flavors
Lets start by creating some flavors that will be required for our VNFs (Virtual Machines).

A flavor is required for each of the following:

| flavor-name | vCPUs | vRAM (MB) | vDisk (GB) |
|--------------|-------|-----------|------------|
| tenantXXX-csr1kv.small | 2 | 4096 | 0 |
| tenantXXX-m1.nano | 1 | 64 | 1 |

In order to create a flavor with with 1 vCPU, 64 MB of vRAM and 1 GB of vDisk with a name of tenant99-m1.nano available to tenant99, the following command would be used:

```
$ openstack flavor create --project tenantXXX --ram 64 --vcpus 1 --disk 1 --private tenantXXX-m1.nano
+----------------------------+--------------------------------------+
| Field                      | Value                                |
+----------------------------+--------------------------------------+
| OS-FLV-DISABLED:disabled   | False                                |
| OS-FLV-EXT-DATA:ephemeral  | 0                                    |
| disk                       | 1                                    |
| id                         | 4382f519-24c2-4cff-8b94-cc22537dcd3c |
| name                       | tenantXXX-m1.nano                     |
| os-flavor-access:is_public | False                                |
| properties                 |                                      |
| ram                        | 64                                   |
| rxtx_factor                | 1.0                                  |
| swap                       |                                      |
| vcpus                      | 1                                    |
+----------------------------+--------------------------------------+
```

*Note: there are many other options that can be specified, these options can be explored by executing `openstack flavor create --help` command*

*Note: Replace XXX with your POD number. You will have this in your handout page*

## Create Networks and Subnets

Let's start by creating the provider network, this is the only one that must be created using an admin user because it is the one that needs to provide values that only the OpenStack cloud administrator would have.

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

Step 4 - Fill in all the values for the subnet details and click on **Create**
![Step 4](./images/admin_network_provider_create_04.png)

Step 5 - A green notification should appear on the top-right corner indicating successful creation of the network and subnet
![Step 5](./images/admin_network_provider_create_05.png)

## Create images

We need to create the following images in glance.

| Image Name | Format | Shared | File Name |
|--------------|-------|-----------|------------|
| tenantXXX-csr1kv-3.16.6s | qcow2 | No | csr3.16.6s.qcow2 |
| tenantXXX-cirros-0.4.0-x86_64 | qcow2 | No | cirros-0.4.0-x86_64-disk.img |

Next you will find the steps to upload the image either via Horizon or OpenStack CLI.

*Note: You need to execute the procedure for all the images in the table. The procedure is explained for one image but the same procedure is valid for all of them.*

The files can be downloaded from this [link](http://172.31.56.131/download/) and from the command line they can be downloaded using wget (e.g. `wget http://172.31.56.131/download/cirros-0.4.0-x86_64-disk.img`

Upload image using single OpenStack CLI command:
```
$ openstack image create --project tenantXXX --disk-format qcow2 --file cirros-0.4.0-x86_64-disk.img tenantXXX-cirros-0.4.0-x86_64
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
| name             | tenant99-cirros-0.4.0-x86_64                         |
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

## Create Floating IP Pool

Step 1 - Go to Admin -> Network -> Floating IPs an click on **Allocate IP To Project**
![Step 1](./images/admin_floating_ip_pool_create_01.png)

Step 2 - Fill in the values and click on **Allocate Floating IP**
![Step 2](./images/admin_floating_ip_pool_create_02.png)

Step 3 - A green notification should appear on the top-right corner indicating successful allocation of floating IP
![Step 3](./images/admin_floating_ip_pool_create_03.png)
*Note: There is a bug when trying to assign a specific IP from Horizon dashboard, for the moment this must be done from the CLI if a specific IP is required.*

```
$ openstack floating ip create --project tenantXXX --floating-ip-address 172.31.57.XXX external
+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| created_at          | 2018-01-21T22:46:21Z                 |
| description         |                                      |
| fixed_ip_address    | None                                 |
| floating_ip_address | 172.31.57.99                        |
| floating_network_id | 06ca5380-84eb-46b1-b0db-8fa038f72998 |
| id                  | 958a5fd7-72ef-426a-9aef-dd6bbbac6501 |
| name                | 172.31.57.99                        |
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
*Estimated time to complete: 60 min.*

## Create Networks and Subnets

As a tenant user we will need to create two networks, one that connects CSR1Kv to the Internet and the other one that will connect the internal VM to CSR1Kv

## Create Internet Network and Subnet

Lets start by creating the Internet network.

Since the Internet network does not have connectivity to the outside world (It is only relevant for the tenant) the same value can be reused by all tenants.

|  Tenant   | Network Address  |  Gateway IP   |         Allocation Pools        |
|-----------|------------------|---------------|---------------------------------|
| TenantXXX | 192.168.254.0/24 | 192.168.254.1 | 192.168.254.2 - 192.168.254.254 |

Step 1 - Go to Project -> Network -> Networks and click on **Create Network**
![Step 1](./images/member_network_internet_create_step_01.png)

Step 2 - Fill in all the values for the network and click on **Next**
![Step 2](./images/member_network_internet_create_step_02.png)

Step 3 - Fill in all the values for the subnet and click on **Next**
![Step 3](./images/member_network_internet_create_step_03.png)

Step 4 - Fill in all the values for the subnet details and click on **Create**
![Step 4](./images/member_network_internet_create_step_04.png)

Step 5 - A green notification should appear on the top-right corner indicating successful creation of the network and subnet
![Step 5](./images/member_network_internet_create_step_05.png)

## Create Internal Network and Subnet

Lets create now the Internal Network. This time we will do it via OpenStack CLI.

```
$ openstack network create tenant99-internal
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
| name                      | tenant99-internal                    |
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

$ openstack subnet create --network tenant99-internal --subnet-range 192.168.255.0/24 tenant99-internal-subnet
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
| name                    | tenant99-internal-subnet             |
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

Since the Internal network does not have connectivity to the outside world either the same value can be reused by all tenants.

|  Tenant  | Network Address  |  Gateway IP   |         Allocation Pools        |
|----------|------------------|---------------|---------------------------------|
| TenantXX | 192.168.255.0/24 | 192.168.255.1 | 192.168.255.2 - 192.168.255.254 |

## Create OpenStack Router
- tenantXX-router

Step 1 - Go to Project -> Network -> Routers and click on **Create Router**
![Step 1](./images/member_routers_create_step_01.png)

Step 2 - Fill in all the values for the router and click on **Create Router** button
![Step 2](./images/member_routers_create_step_02.png)

Step 3 - A green notification should appear on the top-right corner indicating successful creation of the router
![Step 3](./images/member_routers_create_step_03.png)

### Attach router to provider network

Step 1 - Go to Project -> Network -> Routers and click on the router that was created in the previous step, go to the Interfaces tab and click on **Add Interface**
![Step 1](./images/member_routers_attach_interface_internet_step_01.png)

Step 2 - Select tenantXX-internet from the drop-down list of subnets and click on **Submit**
![Step 2](./images/member_routers_attach_interface_internet_step_02.png)

Step 3 - A green notification should appear on the top-right corner indicating successful attach of the subnet to the router
![Step 3](./images/member_routers_attach_interface_internet_step_03.png)

## Launch Instances

### Security Groups

In order for our CSR1Kv instance to work properly, we have to create a security group and allow all inbound traffic that is desired. For the purpose of our lab, we will create multiple security groups so that they can be easily identifiable.

The following table lists the security groups that need to be created:

| Security Group Name  | Rule | Direction | Remote | CIDR |
|----------------------|:------:|:-----------:|:--------:|------|
| tenantXXX-allow_ssh  | SSH  | N/A       | CIDR   | 0.0.0.0/0 |
| tenantXXX-allow_icmp | ALL ICMP | Ingress | CIDR | 0.0.0.0/0 |

Step 1 - Go to Project -> Network -> Security Groups and click on **Create Security Group**.
![Step 1](./images/member_create_security_groups_step_01.png)

Step 2 - Type the security group name (do not forget to replace XXX with your POD number) and click on **Create Security Group**.
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

### Launch CSR1Kv Instance

There are several steps required to create the instance, and there are multiple ways to do this. The suggested way is via OpenStack CLI, this will allow us to create the instance with a single command and provide all the proper IPv4 addresses.

Step 1 - Issue the `openstack network list` command to find the IDs for the networks that we want to attach to CSR1Kv.
```
$ openstack network list
+--------------------------------------+-------------------+--------------------------------------+
| ID                                   | Name              | Subnets                              |
+--------------------------------------+-------------------+--------------------------------------+
| 06ca5380-84eb-46b1-b0db-8fa038f72998 | external          | 9b34213c-eff1-4008-a387-d08ee49b5ee0 |
| 2c3d2f04-41ed-4c1a-956d-e57f61758f1e | tenant99-internet | 49eaed11-788e-41dd-8823-12964c9f90e5 |
| 2f25227b-80b0-4f31-b11b-9b2d8066127c | tenant99-internal | 2bb680e4-2da0-4f51-9b52-ad41e006ad43 |
| 631e32e7-8e1f-42fb-a927-ec1d7dc31293 | tenant-net        | f57b9855-42fb-406a-bb31-c25036078f07 |
| 90c70132-0ea7-4362-8ab4-aff50986d012 | tenant99-provider | e7210532-3d56-4eaf-9826-0711756ad3f4 |
+--------------------------------------+-------------------+--------------------------------------+
```

Step 2 - After the networks have been identified, replace each net-id with the corresponding ID found with in *Step 1*
```
openstack server create --flavor tenant99-csr1kv.small --image tenant99-csr1kv-3.16.6s \
  --nic net-id=2c3d2f04-41ed-4c1a-956d-e57f61758f1e,v4-fixed-ip=192.168.254.10 \
	--nic net-id=90c70132-0ea7-4362-8ab4-aff50986d012,v4-fixed-ip=172.16.99.10 \
	--nic net-id=2f25227b-80b0-4f31-b11b-9b2d8066127c,v4-fixed-ip=192.168.255.1 \
	--security-group tenant99-allow_ssh \
	--security-group tenant99-allow_icmp \
	tenant99-csr1kv
```

*Note: for tenantXX-provider replace the IPv4 address with an appropiate network from the tenantXX-provider network.*

### Launch CirrOS Instance

In order to test connectivity from behind the CSR1Kv, we will be creating a CirrOS instance that will act as our PC in the topology.

This time we will launch the CirrOS VM from the horizon dashboard.

Step 1 - Go to Project -> Compute -> Instances and click on **Laumch Instance**
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

Now let's go to CirrOS instance and try to execute a ping from it to the CSR1Kv interface, you will notice that ping will work (if this is not working, ensure that you attached the allow_icmp security group, if everything else fails, go [here](#neutron-intensive-tasks)).

However if from the CirrOS instance you try to ping the IPv4 address of tenantXX-provider network, it will fail. Can you figure out why it is failing ? Hint: It does not have anything to do with routing.

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

## Set Return Routes for Router
After setting the allowed address pairs, you will notice that you are able to ping the tenantXXX-internet IPv4 address of the CSR1kv, however you are not able to ping the IPv4 address of tenantXXX-internet's default gateway (which is OpenStack's router), why ?

If you execute the following command you will notice that the line for routes is blank:
```
$ openstack router show tenant99-router
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
| name                    | tenant99-router                                                                                                                                                                          |
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
$ openstack router set --route destination=192.168.255.0/24,gateway=192.168.254.6 tenant99-router
$ openstack router show tenant99-router
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
| name                    | tenant99-router                                                                                                                                                                          |
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

* In this section, you need to execute the commands from the host that is hosting your CSR1Kv router-VM. So, the first step would be to find the host that is running your CSR1Kv VM.
* Please note that we are using Openstack’s L3 agent router to route traffic to Internet. And, this router is hosted on the Network-node, which is 172.31.56.216 (this is also the Controller and a Compute node).

## Topology
![neutron-1](https://github.com/userlerueda/LTRCLD-1451/blob/master/images/neutron-network-1.png)

## Packet path

In this below example diagram, our VM is hosted on a compute node. Here the VM is CSR1Kv router.
![neutron-3](https://github.com/userlerueda/LTRCLD-1451/blob/master/images/neutron-3.png)

Red dotted line represents path from CSR1Kv to Internet. If you notice, traffic goes to Network node and reaches Internet via the openstack-router. Here, Controller node is functioning as Network node.

Including Network node, there are 6 nodes in our setup. br-tun bridge would have 5 VXLAN-tunnel interfaces to going to br-tun bridges on the other nodes.

The tasks below will navigate packet path, from CSR1Kv to Internet. This diagram may be needed for reference while you are working on the steps below. You may want to open this [diagram](https://github.com/userlerueda/LTRCLD-1451/blob/master/images/neutron-3.png) in a new tab (right click and "open in a new tab").

## Packet tracing tasks

* Login to Controller node: `ssh tenantXXX@172.31.56.216`
* Load Openstack environment variables: `source keystonerc_adminXXX`
* Find the node which is hosting your CSR1Kv rotuer
	* `openstack server list`
	* `openstack server show <csr1kv VM name>`

Example: In the example below, PSL-DMZ-C-S2 (compute-2) is the host.

```
[tenant99@PSL-DMZ-C-S6 ~( admin99@tenant99 )]$ openstack server list
+--------------------------------------+-----------------+--------+--------------------------------------------------------------------------------------------------+------------------------------+-----------------------+
| ID                                   | Name            | Status | Networks                                                                                         | Image                        | Flavor                |
+--------------------------------------+-----------------+--------+--------------------------------------------------------------------------------------------------+------------------------------+-----------------------+
| 9de2e138-9d5c-49c4-8d4d-b0a981fda859 | tenant99-pc     | ACTIVE | tenant99-internal=192.168.255.5                                                                  | tenant99-cirros-0.4.0-x86_64 | tenant99-m1.nano      |
| 12a00eb4-5198-4fde-933c-4c6d1d047cda | tenant99-csr1kv | ACTIVE | tenant99-internet=192.168.254.6; tenant99-internal=192.168.255.1; tenant99-provider=172.16.99.10 | tenant99-csr1kv-3.16.6s      | tenant99-csr1kv.small |
+--------------------------------------+-----------------+--------+--------------------------------------------------------------------------------------------------+------------------------------+-----------------------+
[tenant99@PSL-DMZ-C-S6 ~( admin99@tenant99 )]$ openstack server show tenant99-csr1kv
+-------------------------------------+--------------------------------------------------------------------------------------------------+
| Field                               | Value                                                                                            |
+-------------------------------------+--------------------------------------------------------------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                                                                           |
| OS-EXT-AZ:availability_zone         | nova                                                                                             |
| **OS-EXT-SRV-ATTR:host**            | **PSL-DMZ-C-S2**                                                                                 |
| OS-EXT-SRV-ATTR:hypervisor_hostname | compute-2                                                                                        |
| OS-EXT-SRV-ATTR:instance_name       | instance-00000023                                                                                |
| OS-EXT-STS:power_state              | Running                                                                                          |
| OS-EXT-STS:task_state               | None                                                                                             |
| OS-EXT-STS:vm_state                 | active                                                                                           |
| OS-SRV-USG:launched_at              | 2018-01-25T18:52:47.000000                                                                       |
| OS-SRV-USG:terminated_at            | None                                                                                             |
| accessIPv4                          |                                                                                                  |
| accessIPv6                          |                                                                                                  |
| addresses                           | tenant99-internet=192.168.254.6; tenant99-internal=192.168.255.1; tenant99-provider=172.16.99.10 |
| config_drive                        |                                                                                                  |
| created                             | 2018-01-25T18:52:34Z                                                                             |
| flavor                              | tenant99-csr1kv.small (1801fafb-6bce-4e88-ba78-8043bd716224)                                     |
| hostId                              | fe5a79620cb1788e98ff96e3c47452bff3dac6dc30184c1ec7eab25b                                         |
| id                                  | 12a00eb4-5198-4fde-933c-4c6d1d047cda                                                             |
| image                               | tenant99-csr1kv-3.16.6s (3655b9fa-e2c5-421e-b2e1-65410288d28b)                                   |
| key_name                            | None                                                                                             |
| name                                | tenant99-csr1kv                                                                                  |
| progress                            | 0                                                                                                |
| project_id                          | 1e2b5c63d1f14091b237acf064cc9db6                                                                 |
| properties                          |                                                                                                  |
| security_groups                     | name='default'                                                                                   |
|                                     | name='default'                                                                                   |
|                                     | name='default'                                                                                   |
| status                              | ACTIVE                                                                                           |
| updated                             | 2018-01-25T18:52:47Z                                                                             |
| user_id                             | 61a72633cdf0432b8c6c69c3bc444e70                                                                 |
| volumes_attached                    |                                                                                                  |
+-------------------------------------+--------------------------------------------------------------------------------------------------+
[tenant99@PSL-DMZ-C-S6 ~( admin99@tenant99 )]$
```

* Login to Controller node: `ssh tenantXXX@<host-name>`
	* make sure you are in the **right host** by checking its hostname.
* Load Openstack environment variables: `source keystonerc_adminXXX`

```
[tenant99@PSL-DMZ-C-S6 ~( admin99@tenant99 )]$ ssh tenant99@PSL-DMZ-C-S2
tenant99@psl-dmz-c-s2's password:
There were 4 failed login attempts since the last successful login.
[tenant99@PSL-DMZ-C-S2 ~]$ source keystonerc_admin99
[tenant99@PSL-DMZ-C-S2 ~( admin99@tenant99 )]$
```
* Find the port-id of Internet-facing port
	* `openstack server list | grep csr`
	*


*Review the section and discuss if you have any questions or comments.*

---

# OpenStack Review Tasks
*Estimated time to complete: 30 min.*

In this concluding section, you will try to get an overall view of the Openstack cloud that you just worked on. Try to make sense of the output of each command. These are some commonly used monitoring commands. Not every command and output may have a direct connection to the work that you did so far. The goal is to get an overall idea, not necessarily a detailed one.

Please note that a typical production NFV system or Openstack cloud includes components such as exclusive storage, high performance network connectivity with PCIe or SR-IOv, OSS/BSS system, VNF management system, and Orchestration systems. In this lab, we have Openstack alone, which makes up ETSI model’s Virtual Infrastructure Manager (VIM).

* login into Controller node: `ssh tenantXXX@172.31.56.216`
	* Use **putty** app provided in your lab laptop
	* IP address: `172.31.56.216`
	* username: `tenantXXX`
	* password: `cisco.123`
* Load environment parameters for Openstack access:$ `source keystonerc_adminXXX`

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
[tenant130@PSL-DMZ-C-S6 ~( admin130@tenant130 )]$ openstack network list | awk '{ print $2 }'

ID

04eea3ef-4bd0-4a53-bb41-9ee306fce37f
06ca5380-84eb-46b1-b0db-8fa038f72998
2c3d2f04-41ed-4c1a-956d-e57f61758f1e
2f25227b-80b0-4f31-b11b-9b2d8066127c
5da13369-b2ea-422b-9b9d-e3c93ec1acdb
631e32e7-8e1f-42fb-a927-ec1d7dc31293
90c70132-0ea7-4362-8ab4-aff50986d012

[tenant130@PSL-DMZ-C-S6 ~( admin130@tenant130 )]$ openstack network list | grep external | awk '{ print $2 }'
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

<p align="center">
**End of session**
</p>

---
