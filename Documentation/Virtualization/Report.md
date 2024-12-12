![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍Report🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Executive Summary](#📝executive-summary)
3. [✨The actual report](#✨the-actual-report)
    1. [👉Introduction](#👉introduction)
        1. [👉VMware](#👉vmware)
        2. [👉The problem](#👉the-problem)
        3. [👉The solution](#👉the-solution)
            1. [👉Openstack](#👉openstack)
            2. [👉Previous obstacles](#👉previous-obstacles)
            3. [👉Current situation](#👉current-situation)
    2. [👉Content chapters](#👉content-chapters)
        1. [👉A basic OpenStack installation](#👉a-basic-openstack-installation)
        2. [👉Setup](#👉setup)
            1. [👉Ubuntu Setup](#👉ubuntu-setup)
            2. [👉MySQL Setup](#👉mysql-setup)
            3. [👉RabbitMQ Setup](#👉rabbitmq-setup)
            4. [👉Memcached Setup](#👉memcached-setup)
            5. [👉Etcd Setup](#👉etcd-setup)
        3. [👉Keystone](#👉keystone)
            1. [👉Installation](#👉installation)
            2. [👉Domain, projects, users and roles](#👉domain-projects-users-and-roles)
        4. [👉Glance](#👉glance)
            1. [👉Installation](#👉installation-1)
            2. [👉Verify](#👉verify)
        5. [👉Placement](#👉placement)
            1. [👉Installation](#👉installation-2)
        6. [👉Nova](#👉nova)
            1. [👉Installation (controller node)](#👉installation-controller-node)
            2. [👉Installation (compute node)](#👉installation-compute-node)
        7. [👉Neutron](#👉neutron)
            1. [👉Installation (controller node)](#👉installation-controller-node-1)
            2. [👉Installation (compute](#👉installation-compute)
        8. [👉Horizon](#👉horizon)
            1. [👉Installation](#👉installation)
            2. [👉Configuration](#👉configuration)
        9. [👉Migreren](👉migreren)
            1. [👉VMware naar Openstack](#👉vmware-naar-openstack)
            2. [👉Third-party solution](#👉third-party-solution)
        10. [👉Launch an instance](👉launch-an-instance)
        11. [🔭Conclusion](#🔭conclusion)
        12. [🔗References](#🔗references)

---

## 📝Executive Summary
This report explores the possibility of migrating from VMware to OpenStack as a cloud infrastructure solution. The dissatisfaction with recent decisions by Broadcom, the current owner of VMware, has led many companies to seek alternative solutions. OpenStack, an open-source project managed by the OpenInfra Foundation, presents itself as a viable option.
- ***Here are the key points***:
  - **Problem**: VMware's recent changes in licensing, pricing, and partner programs have caused dissatisfaction among customers.
  - **Solution**: OpenStack offers a free, open-source alternative with a mature feature set and a large community of users and developers and is already being utilized by large enterprises such as Walmart and Paypal for example.
- ***Benefits of OpenStack***:
  - **Cost-effective**: OpenStack eliminates vendor lock-in and avoids expensive licensing fees by being an open-source initiative.
  - **Customization**: OpenStack offers greater flexibility and customization compared to proprietary solutions, not only through its open-source nature but also through its modular structure.
  - **Scalability**: OpenStack can scale to meet the needs of large and growing organizations.
  - **Challenges**: Setting up OpenStack is known to be more complex than managed solutions.
- ***Report Structure***:
  - **Introduction**: Discusses the problems with VMware and introduces OpenStack as a solution.
  - **Content Chapters**: Details the steps involved in setting up a basic OpenStack environment and how to migrate your VMware machines to OpenStack.
  - **Conclusion**: Summarizes the benefits of OpenStack and its suitability as a replacement for VMware.
- ***Conclusion***:
  - OpenStack is a strong alternative to VMware, especially for companies looking to avoid vendor lock-in and reduce costs. While the initial setup may be more complex, the long-term benefits outweigh the initial investment. This report provides a foundational understanding of OpenStack and its core components. Further research is recommended to delve deeper into specific use cases and migration strategies.

## ✨The actual report

### 👉Introduction

#### 👉VMware

When VMware came into the world, the new x86 servers offered the possibility to run multiple VMs on one physical server and manage them via hypervisors. Later they also added VDI (Virtual Desktop Infrastructure) and MDM (Mobile Device Management) to their portfolio. So they were pioneers in the virtualization sector.

#### 👉The problem

VMware has had several owners throughout its history, the most recent of which is Broadcom who acquired them for $69 billion. Broadcom plans to shift their focus to VMware Cloud Foundation, the foundation for private and hybrid clouds.

The following decisions caused huge dissatisfaction among customers:
- Terminating existing partner agreements and only moving a select few partners to their own partner program
- Eliminating advantageous academic discounts, other product bundles that are more expensive, license adjustments -> costs skyrocket
- ​​Requiring VMware Cloud Service Provider customers to accept new minimum commitments, which is much more expensive, possibly unnecessary and sometimes simply not feasible for smaller companies.
- Transitioning to subscription-only licensing by eliminating perpetual licenses.
- Laying off over 2,800 VMware employees.

#### 👉The solution

A possible alternative and also the alternative that will be examined in more detail in this report is Openstack. Why would you go for Openstack?

##### 👉Openstack

Openstack is an open-source project managed by the OpenInfra Foundation, a non-profit organization working on an open and neutral environment, so that companies, developers and users can collaborate on open-source infrastructure software. Openstack focuses mainly on offering cloud software, which is completely free by the way.

##### 👉Previous obstacles

- **Complexity:** Initially, Openstack was complex to set up and manage. This meant that there was a high learning threshold for companies that did not have extensive experience with similar technologies.
- **Scalability:** Especially for larger companies, it was questionable whether Openstack would scale well in terms of performance, availability and manageability.
- **Entrepreneurial support:** Due to its open-source nature, there was initially a lack of commercial support and functionality specifically aimed at companies.

##### 👉Current situation

After 14 years they finally got it. Today it is a mature solution that has solved its former weaknesses. This is noticeable by the various magnates that now use Openstack. These include large enterprises and service providers such as China Mobile and Walmart, leading tech companies such as Blizzard Entertainment and Paypal and public cloud providers such as VEXXHOST and DreamHost. This large range of impressive customers is a testament to their current capabilities. We can conclude that Openstack has certainly become a worthy alternative to VMware.

### 👉Content chapters

#### 👉A basic OpenStack installation

To set up an OpenStack environment with only the essential components, the following services are required. These are the core functionality for managing virtual infrastructure:
1. **Keystone (Identity Service)**
  - Keystone is responsible for authentication and authorization within OpenStack. It acts as a central identity management service that allows users and services to access OpenStack resources.
2. **Glance (Image Service)**
  - Glance manages virtual machine images. This service allows you to upload, store, and manage images so that other services, such as Nova, can use them to launch virtual machines.
3. **Placement (Placement Service)**
  - Placement helps efficiently allocate resources, such as CPU, memory, and disk space, to virtual machines. It works closely with Nova to determine which resources are available and how best to utilize them.
4. **Nova (Compute Service)**
  - Nova is the OpenStack compute engine responsible for starting, managing, and terminating virtual machines. It provides the computing power within the cloud and relies on other services, such as Neutron and Glance, for network access and images.
5. **Neutron (Network Service)**
  - Neutron manages network connectivity within OpenStack. It provides functionality such as network isolation, routers, and firewalls. Neutron is essential for establishing connections between virtual machines and external networks.
6. **Horizon (Dashboard)**
  - Horizon provides a graphical user interface (GUI) that allows users and administrators to easily access OpenStack functionality. This dashboard allows for resource management without using command-line tools.

![Rapport](/Images/Rapport.png)

When setting up this minimal configuration, it is recommended to install the services in the following order:
- Keystone
- Glance
- Placement
- Nova and Neutron (these two services are tightly intertwined and often need to be configured in parallel or iteratively)
- Horizon
This ensures that all dependencies are set up correctly. Once these core services are up and running, OpenStack can be used to create and manage virtual infrastructure.

#### 👉Setup

##### 👉Ubuntu Setup

/etc/netplan/01-netcfg.cnf
```yaml
network:
  version: 2
  ethernets:
    ens18: # Public adapter
      dhcp4: no
      dhcp6: no
      addresses:
        - 10.134.188.11/27
      nameservers:
        addresses:
          - 10.194.17.2
          - 8.8.8.8
    ens19: # Private adapter
      dhcp4: no
      dhcp6: no
      optional: true
```

/etc/hosts
```txt
10.134.188.11 server1
10.134.188.12 server2
```

```bash
vim /etc/sysctl.conf
# net.ipv4.ip_forward = 1
# net.ipv4.conf.default.rp_filter = 0
# net.ipv4.conf.all.rp_filter = 0
```

```bash
server1 $ apt install chrony
server1 $ vim /etc/chrony/chrony.conf
allow 10.134.188.0/27
server1 $ service chrony restart 
```

```bash
severs1,2: $ apt install chrony
severs1,2: $ vim /etc/chrony/chrony.conf 
pool lijnen vervangen met: server server1 iburst 
severs1,2: $ service chrony restart
$ reboot
```

```bash
$ add-apt-repository cloud-archive:caracal
$ apt install python3-openstackclient
server1 $ apt install mariadb-server python3-pymysql
```

##### 👉MySQL Setup

```bash
server1 $ vim /etc/mysql/mariadb.conf.d/99-openstack.cnf
[mysqld]
bind-address = 10.134.188.11

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
server1 $ service mysql restart
server1 $ mysql_secure_installation
…

Enter current password for root (enter for none):
OK, successfully used password, moving on...

…

Switch to unix_socket authentication [Y/n] n
 ... skipping.
…

Change the root password? [Y/n] n
 ... skipping.
…

Remove anonymous users? [Y/n] y
 ... Success!

…

Disallow root login remotely? [Y/n] n
 ... skipping.
…

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!
…

Reload privilege tables now? [Y/n] y
 ... Success!
…
```

##### 👉RabbitMQ Setup

```bash
server1 $ apt install rabbitmq-server 
server1 $ rabbitmqctl add_user openstack [password for rabbitmq]
server1 $ rabbitmqctl set_permissions openstack "." "." ".*"
```
- Ons password voor rabbitmq is 123

##### 👉Memcached Setup

```bash
server1 $ apt install memcached python3-pymemcache 
server1 $ vim /etc/memcached.conf
replace -l 127.0.0.1 with -l 10.134.188.11 
server1 $ service memcached restart
```

##### 👉Etcd Setup

```bash
server1 $ apt install etcd
server1 $ vim /etc/default/etcd
ETCD_NAME="server1"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01" ETCD_INITIAL_CLUSTER="server1=http://10.134.188.11:2380/" ETCD_INITIAL_ADVERTISE_PEER_URLS="http://10.134.188.11:2380/" ETCD_ADVERTISE_CLIENT_URLS="http://10.0.0.11:2379/" ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380/" 
ETCD_LISTEN_CLIENT_URLS="http://10.0.0.11:2379/" 
server1 $ systemctl enable etcd
server1 $ systemctl restart etcd
```

#### 👉Keystone

##### 👉Installation

```bash
server1 $ mysql (run as root) 

maak een keystone databank aan: 
MariaDB [(none)]> CREATE DATABASE keystone; 

configureer de juiste access tot de databank: 
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \ IDENTIFIED BY 'KEYSTONE_DBPASS'; MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \ IDENTIFIED BY 'KEYSTONE_DBPASS'; 
(vervang KEYSTONE_DBPASS met paswoord, bij ons 123) 

server1 $ apt install keystone 

server1 $ vim /etc/keystone/keystone.conf 

"[database] 
connection = mysql+pymysql://keystone:123@server1/keystone 

[token] 
provider = fernet"

server1 $ su -s /bin/sh -c "keystone-manage db_sync" keystone 
server1 $ keystone-manage fernet_setup --keystone-user keystone --keystone-group server1 $ keystone keystone-manage credential_setup --keystone-user keystone --keystone-group keystone keystone-manage bootstrap --bootstrap-password 123 \ --bootstrap-admin-url http://server1:5000/v3/ \ --bootstrap-internal-url 
http://server1:5000/v3/ \ --bootstrap-public-url http://server1:5000/v3/ \ --bootstrap-region-id RegionOne 

server1 $ vim /etc/apache2/apache2.conf 


"ServerName server1"

server1 $ service apache2 restart 
server1 $ export OS_USERNAME=admin 
server1 $ export OS_PASSWORD=123 
server1 $ export OS_PROJECT_NAME=admin 
server1 $ export OS_USER_DOMAIN_NAME=Default 
server1 $ export OS_AUTH_URL=http://server1:5000/v3 
server1 $ export OS_IDENTITY_API_VERSION=3 
```

##### 👉Domain, projects, users and roles

```bash
Create domain, projects, users and roles for the identity service:

(optioneel)
server1 $ openstack domain create --description "An Example Domain" example

server1 $ openstack project create --domain default --description "Service Project" service

server1 $ openstack project create --domain default --description "Demo Project" demoproject

server1 $ openstack user create --domain default --password-prompt demouser

server1 $ openstack role create demorole

server1 $ openstack role add --project demoproject --user demouser demorole
```

```bash
server1 $ vim /root/admin-openrc

export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=123
export OS_AUTH_URL=http://server1:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

server1 $ vim /root/demo-openrc

export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demoproject
export OS_USERNAME=demouser
export OS_PASSWORD=123
export OS_AUTH_URL=http://server1:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

to use:
server1 $ . admin-openrc

server1 $ openstack token issue
```

#### 👉Glance

##### 👉Installation

```bash
server1 $ mysql

MariaDB [(none)]> CREATE DATABASE glance;

MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
  IDENTIFIED BY 'GLANCE_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
  IDENTIFIED BY 'GLANCE_DBPASS';
(DB_PASS is opnieuw 123)

(exit mysql)

server1 $ . admin-openrc

server1 $ openstack user create --domain default --password-prompt glance
(password = 123)

server1 $ openstack role add --project service --user glance admin
```

```bash
server1 $ apt install glance

server1 $ vim /etc/glance/glance-api.conf
[database]
connection = mysql+pymysql://glance:123@server1/glance

[keystone_authtoken]
www_authenticate_uri  = http://server1:5000
auth_url = http://server1:5000
memcached_servers = server1:11211

auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = 123

[paste_deploy]
flavor = keystone

[DEFAULT]
enabled_backends=fs:file

[glance_store]
default_backend = fs

[fs]
filesystem_store_datadir = /var/lib/glance/images/

[oslo_limit]
auth_url = http://server1:5000
auth_type = password
user_domain_id = default
username = glance
system_scope = all
password = 123
endpoint_id = 340be3625e9b4239a6415d034e98aace
region_name = RegionOne"

# Make sure that the glance account has reader access to system-scope resources:
server1 $ openstack role add --user glance --user-domain Default --system all reader

# sync de database
server1 $ su -s /bin/sh -c "glance-manage db_sync" glance

server1 $ service glance-api restart
```

##### 👉Verify

- Verify the installation of glance by uploading CirrOS, a small linux image that helps testing an openstack deployment.

```bash
server1 $ . admin-openrc

server1 $ wget 'http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img'

upload the image to the image service, qcow2 format for qemu and visibility public zodat all projecten er aan kunnen:
server1 $ glance image-create --name "cirros" \
  --file cirros-0.4.0-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --visibility=public

# controleer of de image ingeladen werd:
server1 $ glance image-list
```

#### 👉Placement

##### 👉Installation

```bash
server1 $ mysql

MariaDB [(none)]> CREATE DATABASE placement;

MariaDB [(none)]> GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' \
  IDENTIFIED BY '123';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' \
  IDENTIFIED BY '123';

(exit mysql)

server1 $ . admin-openrc

maak een placement user aan:
server1 $ openstack user create --domain default --password-prompt placement

voeg placement toe aan het service project:
server1 $ openstack role add --project service --user placement admin

server1 $ openstack service create --name placement --description "Placement API" placement

enpoints open zetten
server1 $ openstack endpoint create --region RegionOne placement public "http://server1:8778"
server1 $ openstack endpoint create --region RegionOne placement internal "http://server1:8778"
server1 $ openstack endpoint create --region RegionOne placement admin "http://server1:8778"
```

```bash
server1 $ apt install placement-api
server1 $ vim /etc/glance/placement-api.conf 

"[placement_database]
connection = mysql+pymysql://placement:123@server1/placement

[api]
auth_strategy = keystone

[keystone_authtoken]
auth_url = http://server1:5000/v3
memcached_servers = server1:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = placement
password = 123"

# sync de database met de placement config
server1 $ su -s /bin/sh -c "placement-manage db sync" placement

server1 $ service apache2 restart
```

#### 👉Nova

##### 👉Installation (controller node)

```bash
server1 $ mysql

MariaDB [(none)]> CREATE DATABASE nova_api;
MariaDB [(none)]> CREATE DATABASE nova;
MariaDB [(none)]> CREATE DATABASE nova_cell0;

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
  IDENTIFIED BY '123';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
  IDENTIFIED BY '123';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
  IDENTIFIED BY '123';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
  IDENTIFIED BY '123';

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
  IDENTIFIED BY '123';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
  IDENTIFIED BY '123';

(exit mysql)
```

```bash
server1 $ . admin-openrc

# create nova user:
server1 $ openstack user create --domain default --password-prompt nova

# add admin role to user:
server1 $ openstack role add --project service --user nova admin

create nova service entity:
server1 $ openstack service create --name nova --description "OpenStack Compute" compute

server1 $ openstack endpoint create --region RegionOne compute public "http://server1:8774/v2.1"
server1 $ openstack endpoint create --region RegionOne compute internal "http://server1:8774/v2.1"
server1 $ openstack endpoint create --region RegionOne compute admin "http://server1:8774/v2.1"
```

```bash
server1 $ apt install nova-api nova-conductor nova-novncproxy nova-scheduler

server1 $ vim /etc/nova/nova.conf

[api_database]
connection = mysql+pymysql://nova:123@server1/nova_api

[database]
connection = mysql+pymysql://nova:123@server1/nova

[DEFAULT]
transport_url = rabbit://openstack:123@server1:5672/

[api]
auth_strategy = keystone

[keystone_authtoken]
www_authenticate_uri = http://server1:5000/
auth_url = http://server1:5000/
memcached_servers = server1:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = 123

[service_user]
send_service_user_token = true
auth_url = https://server1/identity
auth_strategy = keystone
auth_type = password
project_domain_name = Default
project_name = service
user_domain_name = Default
username = nova
password = 123

[DEFAULT]
my_ip = 10.134.188.11

[vnc]
enabled = true
server_listen = $my_ip
server_proxyclient_address = $my_ip

[glance]
api_servers = http://server1:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[placement]
region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://server1:5000/v3
username = placement
password = 123"

server1 $ su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova

server1 $ su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova

server1 $ su -s /bin/sh -c "nova-manage db sync" nova

verify if nova cell0 and cell1 are configured correctly:
server1 $ su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova

server1 $ service nova-api restart
server1 $ service nova-scheduler restart
server1 $ service nova-conductor restart
server1 $ service nova-novncproxy restart
```

##### 👉Installation (compute node)

```bash
server2 $ apt install nova-compute

server2 $ vim /etc/nova/nova.conf

"[DEFAULT]
transport_url = rabbit://openstack:123@server1

[api]
auth_strategy = keystone

[keystone_authtoken]
www_authenticate_uri = http://server1:5000/
auth_url = http://server1:5000/
memcached_servers = server1:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = 123

[service_user]
send_service_user_token = true
auth_url = https://server1/identity
auth_strategy = keystone
auth_type = password
project_domain_name = Default
project_name = service
user_domain_name = Default
username = nova
password = 123

[DEFAULT]
my_ip = 10.134.188.12

[vnc]
enabled = true
server_listen = 0.0.0.0
server_proxyclient_address = $my_ip
novncproxy_base_url = http://server1:6080/vnc_auto.html

[glance]
api_servers = http://server1:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[placement]
region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://server1:5000/v3
username = placement
password = 123
```

```bash
# check if node supports hardware accelleration
server2 $ egrep -c '(vmx|svm)' /proc/cpuinfo
# if it returns a value of 1 or greater it the server supports hardware accel

server2 $ service nova-compute restart
```

```bash
add compute node to the cell database (server1/controller)

server1 $ . admin-openrc

list nova nodes:
server1 $ openstack compute service list --service nova-compute

discover nova nodes:
server1 $ su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova (altijd runnen wanneer je een nieuwe compute node toevoegt, anders wordt deze niet herkent)
```

#### 👉Neutron

##### 👉Installation (controller node)

```bash
server1 $ mysql -u root -p

MariaDB [(none)]> CREATE DATABASE neutron;

MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
  IDENTIFIED BY '123';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
  IDENTIFIED BY '123';

(exit mysql)

server1 $ . admin-openrc

create een neutron user:
server1 $ openstack user create --domain default --password-prompt neutron

add admin role aan neutron user:
server1 $ openstack role add --project service --user neutron admin
server1 $ openstack service create --name neutron \
  --description "OpenStack Networking" network

server1 $ openstack endpoint create --region RegionOne \
  network public "http://server1:9696"
server1 $ openstack endpoint create --region RegionOne \
  network internal "http://server1:9696"
server1 $ openstack endpoint create --region RegionOne \
  network admin "http://server:9696"
server1 $ openstack service create --name neutron \
  --description "OpenStack Networking" network

server1 $ openstack endpoint create --region RegionOne \
  network public "http://server1:9696"
server1 $ openstack endpoint create --region RegionOne \
  network internal "http://server1:9696"
server1 $ openstack endpoint create --region RegionOne \
  network admin "http://server:9696"
```

- We have chosen self-service networks instead of Provider networks, this offers us much more flexibility.
```bash
server1 $ apt install neutron-server neutron-plugin-ml2 \
  neutron-openvswitch-agent neutron-l3-agent neutron-dhcp-agent \
  neutron-metadata-agent

server1 $ vim /etc/neutron/neutron.conf

[DEFAULT]
core_plugin = ml2
service_plugins = router
transport_url = rabbit://openstack:123@server1
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[database]
connection = mysql+pymysql://neutron:123@server1/neutron

[cache]
enabled = true
backend = oslo_cache.memcache_pool
memcache_servers = server1:11211 

[keystone_authtoken]
www_authenticate_uri = http://server1:5000
auth_url = http://server1:5000
memcached_servers = server1:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = neutron
password = 123

[nova]
auth_url = http://server1:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = nova
password = 123

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp

server1 $ vim /etc/neutron/plugins/ml2/openvswitch_agent.ini

[ovs]
bridge_mappings = provider:br-provider
local_ip = 10.134.188.11

ovs-vsctl add-br br-provider
ovs-vsctl add-port br-provider ens19

[agent]
tunnel_types = vxlan
l2_population = true

[securitygroup]
# ...
enable_security_group = true
firewall_driver = openvswitch
#firewall_driver = iptables_hybrid"

server1 $ vim /etc/neutron/l3_agent.ini

"[DEFAULT]
interface_driver = openvswitch"

server1 $ vim /etc/neutron/dhcp_agent.ini

"[DEFAULT]
interface_driver = openvswitch
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true"
```

```bash
Configure metadata agent:

server1 $ vim /etc/neutron/metadata_agent.ini

[DEFAULT]
nova_metadata_host = controller
metadata_proxy_shared_secret = 123

Configure the Compute service to use the Networking service:

server1 $ vim /etc/nova/nova.conf

[neutron]
auth_url = http://server1:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = neutron
password = 123
service_metadata_proxy = true
metadata_proxy_shared_secret = 123"

server1 $ su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

server1 $ service neutron-server restart
server1 $ service neutron-openvswitch-agent restart
server1 $ service neutron-dhcp-agent restart
server1 $ service neutron-metadata-agent restart

server1 $ service neutron-l3-agent restart
```

##### 👉Installation (compute node)

```bash
server2 $ apt install neutron-openvswitch-agent

server2 $ vim /etc/neutron/neutron.conf file

comment out anything under [database]

"[DEFAULT]
transport_url = rabbit://openstack:123@server1

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp

configure open vswitch agent:
Edit the /etc/neutron/plugins/ml2/openvswitch_agent.ini file:

[ovs]
bridge_mappings = provider:br-provider
local_ip = 10.134.188.12

ovs-vsctl add-br br-provider
ovs-vsctl add-port br-provider ens19

[agent]
tunnel_types = vxlan
l2_population = true

[securitygroup]
enable_security_group = true
firewall_driver = openvswitch
#firewall_driver = iptables_hybrid

Configure the Compute service to use the Networking service:
server2 $ vim /etc/nova/nova.conf file

[neutron]
auth_url = http://server1:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = neutron
password = 123"

server2 $ service nova-compute restart

server2 $ service neutron-openvswitch-agent restart
```

#### 👉Horizon

##### 👉Installation

```bash
server1 $ apt install openstack-dashboard

server1 $ vim /etc/openstack-dashboard/local_settings.py file

"OPENSTACK_HOST = "server1"

SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

CACHES = {
	'default': {
    	'BACKEND': 'django.core.cache.backends.memcached.PyMemcacheCache',
    	'LOCATION': 'server1:11211',
	}
}

OPENSTACK_KEYSTONE_URL = "http://%s:5000/identity/v3" % OPENSTACK_HOST

OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True

OPENSTACK_API_VERSIONS = {
	"identity": 3,
	"image": 2,
    "volume": 3,
}

OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"

OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"

TIME_ZONE = "Europe/Brussels""
```

### 👉Migreren

VMware VMs usually use vmdk's (virtual machine disks). However, this type is not directly supported by Openstack. You can run a vSphere cluster via the VMware driver that Openstack provides. In that you can work as you would in a regular vSphere cluster. However, this is complex. There are many different ways to migrate.

#### 👉Via Glance and Cinder

It is also easy to use Openstack services itself. You can first upload your image to Glance, where behind the scenes a conversion to qcow2 or raw is also done.
```bash
openstack image create --disk-format vmdk --container-format bare \
  --public --file <file_path> <name>
```

You can then use that image to create a volume in Cinder.
```bash
openstack volume create \
    --image <image_name_or_id> --size <size_volume_in_GB> \
    <name>
```

Then you can create an instance from this volume.
```bash
openstack server create \
    --flavor $FLAVOR --network $NETWORK \
    --volume <volume_name_or_id>\
    --wait <name>
```

This way you have more control over the creation of your volume such as adding encryption, but Nova can also automatically create an instance with a volume from your image.
```bash
openstack server create \
    --flavor $FLAVOR --network $NETWORK \
    --image <image_name_or_id> --boot-from-volume <size_in_GB> \
    --wait <name>
```

#### 👉Third-party solution

For large workloads this is of course a lot of work to do yourself, especially if your IT team is not that extensive. Fortunately, there are several companies that specialize in this and can therefore offer valuable help. For example, Openstack itself recommends MigrateKit from VEXXHOST, Coriolis from Cloudbase Solutions and ZConverter. The big disadvantage of this is of course that it can cost a bit.

### 👉Launch an instance


- Create virtual network (selfservice option)
```bash
. demo-openrc

openstack network create selfservice

edit /etc/neutron/plugins/ml2/ml2_conf.ini

[ml2]
tenant_network_types = vxlan

[ml2_type_vxlan]
vni_ranges = 1:1000

openstack subnet create --network selfservice \
  --dns-nameserver 10.194.17.2 --gateway 172.16.1.1 \
  --subnet-range 172.16.1.0/24 selfservice
```
```bash
. demo-openrc

openstack router create router

openstack router add subnet router selfservice

openstack router set router --external-gateway provider
```

- Verify operation:
```bash
. admin-openrc
```

- ip netns (there should be 1 router and 2 dhcp's)
```bash
openstack port list --router router (neem het IP adres van de provider router)

ping naar provider router
Create m1.nano flavor (soort machine type om dan te testen)

openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano
openstack flavor create --id 1 --vcpus 2 --ram 2048 --disk 10 m1.medium
```

- Generate a key pair
```bash
. demo-openrc

ssh-keygen -q -N ""

openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey

openstack keypair list (verify dat er een keypair in staat)
```

- Add security group rules (type of firewall)
```bash
openstack security group rule create --proto icmp default

openstack security group rule create --proto tcp --dst-port 22 default
```

- Use this command to launch an instance
```bash
openstack server list
```

- Use this command to show vnc console
```bash
openstack console url show selfservice-instance
```

- if `server1` does not resolve you can add the IP to `/etc/hosts` or fill in the IP in the URL o give an `external ip` to your server you can use the following commands:
```bash
openstack floating ip create provider

openstack server add floating ip selfservice-instance 10.134.188.19

openstack server list # Verify that the floating ip is attached
```

### 🔭Conclusion

In this report, we have set up a basic OpenStack installation with only the essential components. We have installed the following services: Keystone, Glance, Placement, Nova, Neutron, and Horizon. These services provide the core functionality for managing virtual infrastructure. We have described the installation and configuration of each service in detail, including the necessary steps and configuration files. By following these steps, users can set up and manage an OpenStack environment for running virtual machines and managing network connectivity. OpenStack provides a powerful and flexible cloud solution that can be tailored to the needs of different organizations. With proper configuration and management, users can take advantage of the benefits of cloud computing, such as scalability, flexibility, and cost-efficiency.

### 🔗References

- [Install Guide](https://docs.openstack.org/install-guide)

- OpenStack:
  - [OpenStack Documentation](https://docs.openstack.org/)
  - [OpenStack Installation Guide](https://docs.openstack.org/install-guide/)
  - [OpenStack Configuration Reference](https://docs.openstack.org/config-reference/)
  - [OpenStack Networking Guide](https://docs.openstack.org/neutron/latest/)
  - [OpenStack Compute Guide](https://docs.openstack.org/nova/latest/)
  - [OpenStack Identity Guide](https://docs.openstack.org/keystone/latest/)
  - [OpenStack Image Guide](https://docs.openstack.org/glance/latest/)
  - [OpenStack Placement Guide](https://docs.openstack.org/placement/latest/)
  - [OpenStack Dashboard Guide](https://docs.openstack.org/horizon/latest/)
  - [OpenStack Security Guide](https://docs.openstack.org/security-guide/)
  - [OpenStack Operations Guide](https://docs.openstack.org/ops-guide/)
  - [OpenStack API Reference](https://developer.openstack.org/api-guide/quick-start/)
  - [OpenStack Release Notes](https://docs.openstack.org/releasenotes/)
  - [OpenStack Community](https://www.openstack.org/community/)
