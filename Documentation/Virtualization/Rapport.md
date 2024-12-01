![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍Rapport🤍💙

## 0. Table of Contents

0. [0. Table of Contents](#0-table-of-contents)
1. [1. Executive Summary](#1-executive-summary)
2. [2. Het eigenlijke verslag](#2-het-eigenlijke-verslag)
    1. [2.1. Inleiding](#21-inleiding)
        1. [2.1.1. VMware](#211-vmware)
        2. [2.1.2. Het probleem](#212-het-probleem)
        3. [2.1.3. De oplossing](#213-de-oplossing)
            1. [2.1.3.1. Openstack](#2131-openstack)
            2. [2.1.3.2. Vorige obstakels](#2132-vorige-obstakels)
            3. [2.1.3.3. Huidige situatie](#2133-huidige-situatie)
    2. [2.2. Inhoudelijke hoofdstukken](#22-inhoudelijke-hoofdstukken)
        1. [2.2.1. Een basis OpenStack-installatie](#221-een-basis-openstack-installatie)
        2. [2.2.2. Setup](#222-setup)
            1. [2.2.2.1. Ubuntu Setup](#2221-ubuntu-setup)
            2. [2.2.2.2. MySQL Setup](#2222-mysql-setup)
            3. [2.2.2.3. RabbitMQ Setup](#2223-rabbitmq-setup)
            4. [2.2.2.5. Etcd Setup](#2225-etcd-setup)
        3. [2.2.3. Keystone](#223-keystone)
            1. [2.2.3.1. Installatie](#2231-installatie)
            2. [2.2.3.2 Domain, projecten, gebruikers en rollen](#2232-domain-projecten-gebruikers-en-rollen)
        4. [2.2.4. Glance](#224-glance)
            1. [2.2.4.1. Installatie](#2241-installatie)
            2. [2.2.4.2. Verify](#2242-verify)
        5. [2.2.5. Placement](#225-placement)
            1. [2.2.5.1. Installatie](#2251-installatie)
        6. [2.2.6. Nova](#226-nova)
            1. [2.2.6.1. Installatie (controller node)](#2261-installatie-controller-node)
            2. [2.2.6.2 Installatie (compute node)](#2262-installatie-compute-node)
        7. [2.2.7. Neutron](#227-neutron)
            1. [2.2.7.1. Installatie (controller node)](#2271-installatie-controller-node)
            2. [2.2.7.2. Installatie (compute node)](#2272-installatie-compute-node)
        8. [2.2.8. Horizon](#228-horizon)
            1. [2.2.8.1. Installatie](#2281-installatie)
    3. [2.3. Conclusie](#23-conclusie)
    4. [2.4. Aanbevelingen](#24-aanbevelingen)

---

## 1. Executive Summary
[Begin jouw rapport met een executive summary. Een executive summary biedt een compleet overzicht van een rapport. Het is een onafhankelijk gedeelte van het rapport en moet als zodanig los kunnen staan van de rest. De executive summary is een belangrijk onderdeel, omdat dit vaak het enige gedeelte van het rapport is dat wordt gelezen – iets wat vaak het geval is bij managers die rapporten ontvangen van verschillende ingenieurs en andere personeelsleden. Een manager op deze positie wil snel de belangrijke punten van een rapport kunnen zien en niet twintig pagina’s tekst moeten doorlezen. Al er tijdens het lezen van de executive summary specifieke vragen naar boven komen, kan hij het gehele rapport doorlezen om de noodzakelijke details op te zoeken. Als je leert om effectieve executive summaries te schrijven, dan zul je hier veel profijt van hebben in het bedrijfsleven, waar altijd weinig tijd is. Executive summaries moeten beknopt zijn omdat ze veel worden gebruikt, zowel voor interne technische rapporten, als voor rapporten die worden verspreid onder de klanten van een onderneming.
Vorm van een executive summary:
1. Een samenvatting van de belangrijkste punten van de inleiding, de doelen, de achterliggende materie, de procedure en de resultaten van het rapport.
2. Conclusies
3. Aanbevelingen
Een executive summary is heel kort, maximum één getypte bladzijde. Een executive summary schrijf je pas nadat je het hele rapport hebt afgerond.
Bron: Sorby & Bulleit, Communicatieve vaardigheden voor technici, Pearson Education Benelux, 2006]


## 2. Het eigenlijke verslag

### 2.1. Inleiding

#### 2.1.1. VMware

Wanneer VMware in de wereld kwam, bood de mogelijkheid voor de nieuwe x86-servers om meerdere VM’s op één fysieke server te draaien en deze te beheren via hypervisors. Later voegden ze ook VDI (Virtual Desktop Infrastructure) en MDM (Mobile Device Management) toe aan hun assortiment. Ze waren dus pioniers in de virtualisatiesector.

#### 2.1.2. Het probleem

VMware heeft al verschillende eigenaars gehad doorheen de geschiedenis en de recentste daarvan is Broadcom die hen aankocht voor 69 miljard dollar. Broadcom is van plan om hun focus te verleggen naar VMware Cloud Foundation, de fundering voor privé- en hybrideclouds.

Volgende beslissingen zorgden voor enorme ontevredenheid bij de klanten:
    - Het beëindigen van bestaande partnerovereenkomsten en enkel een selectie van die partners overzetten naar eigen partnerprogramma
    - Schrappen van voordelige academische kortingen, andere productenbundels die duurder zijn, aanpassingen licenties -> kosten schieten omhoog
    - VMware Cloud Service Provider klanten verplichten om nieuwe minimum toewijding te accepteren, wat veel duurder, eventueel onnodig en soms gewoonweg niet haalbaar is voor kleinere bedrijven.
    - Transitie naar subscription-only licenties door permanente licenties af te schaffen.
    - Meer dan 2800 VMware werknemers werden ontslagen.

#### 2.1.3. De oplossing

Een mogelijk alternatief en ook het alternatief dat in dit verslag van nader gaat onderzocht worden is Openstack. Waarom zou je voor Openstack gaan? 

##### 2.1.3.1. Openstack

Openstack is een open-source project beheerd door OpenInfra Foundation, een non-profit organisatie die werken aan een open en neutrale omgeving, opdat bedrijven, ontwikkelaars en gebruikers samen aan open-source infrastructuur software. Openstack focust vooral op het aanbieden van cloud software, die trouwens volledig gratis is.

##### 2.1.3.2. Vorige obstakels

- **Complexiteit:** Aanvankelijk was Openstack complex om op te zetten en te beheren. Er was dus een hoge leerdrempel voor bedrijven die geen uigebreide ervaring met gelijkaardige technologieën hadden.
- **Schaalbaarheid:** Vooral voor grotere bedrijven was het betwijfelbaar of Openstack wel goed zou schalen op vlak van performantie, beschikbaarheid en beheersbaarheid.
- **Support voor ondernemeningen:** Vanwege het open-source karakter was er initieel een tekort aan commerciële ondersteuning en functionaliteit specifiek gericht op bedrijven.

##### 2.1.3.3. Huidige situatie

Na 14 jaar hebben ze het dan toch onder de knie gekregen. Tegenwoordig is het een mature oplossing dat zijn vroegere zwaktepunten heeft weggewerkt. Dit valt te merken aan de verschillende magnaten die ondertussen gebruik maken van Openstack. Hierander vallen grote ondernemingen en serice providers zoals China Mobile en Walmart, vooraanstaande techbedrijven zoals Blizzard Entertainment en Paypal en openbare cloud providers zoals VEXXHOST en DreamHost. Deze grote waaier aan indrukwekkende klanten staat testament voor hun huidige kunnen. We kunnen concluderen dat Openstack zeker een waardig alternatief is geworden voor VMware.

### 2.2. Inhoudelijke hoofdstukken

#### 2.2.1. Een basis OpenStack-installatie

Om een OpenStack-omgeving op te zetten met alleen de essentiële componenten, zijn de volgende services nodig. Deze vormen de kernfunctionaliteit voor het beheren van virtuele infrastructuur:
1. **Keystone (Identity Service)**
    - Keystone is verantwoordelijk voor authenticatie en autorisatie binnen OpenStack. Het fungeert als een centrale identity management-service waarmee gebruikers en diensten toegang krijgen tot de OpenStack-resources.
2. **Glance (Image Service)**
    - Glance beheert virtuele machine-images. Deze service maakt het mogelijk om images te uploaden, opslaan, en beheren, zodat andere services, zoals Nova, ze kunnen gebruiken om virtuele machines te starten.
3. **Placement (Placement Service)**
    - Placement helpt bij het efficiënt toewijzen van resources, zoals CPU, geheugen en schijfruimte, aan virtuele machines. Het werkt nauw samen met Nova om te bepalen welke resources beschikbaar zijn en hoe ze het beste kunnen worden benut.
4. Nova **(Compute Service)**
    - Nova is de rekenmodule van OpenStack die verantwoordelijk is voor het opstarten, beheren en beëindigen van virtuele machines. Het biedt de rekenkracht binnen de cloud en is afhankelijk van andere services, zoals Neutron en Glance, voor netwerktoegang en images.
5. Neutron **(Network Service)**
    - Neutron beheert netwerkconnectiviteit binnen OpenStack. Het biedt functionaliteit zoals netwerkisolatie, routers en firewalls. Neutron is essentieel voor het opzetten van verbindingen tussen virtuele machines en externe netwerken.
6. Horizon **(Dashboard)**
    - Horizon biedt een grafische gebruikersinterface (GUI) waarmee gebruikers en beheerders eenvoudig toegang krijgen tot de functionaliteit van OpenStack. Dit dashboard maakt het mogelijk om resources te beheren zonder command-line tools te gebruiken.

![Rapport](/Images/Rapport.png)

Bij het opzetten van deze minimale configuratie wordt aanbevolen de services in de volgende volgorde te installeren:
- Keystone
- Glance
- Placement
- Nova en Neutron (deze twee services zijn nauw verweven en moeten vaak parallel of iteratief worden geconfigureerd)
- Horizon
Dit zorgt ervoor dat alle afhankelijkheden correct worden ingesteld. Zodra deze kernservices draaien, kan OpenStack worden gebruikt voor het aanmaken en beheren van virtuele infrastructuur.

#### 2.2.2. Setup

##### 2.2.2.1. Ubuntu Setup

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
      addresses:
        - 10.0.0.11/24 # Private IP address
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
allow 10.0.0.0/27
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

##### 2.2.2.2. MySQL Setup

```bash
server1 $ vim /etc/mysql/mariadb.conf.d/99-openstack.cnf
[mysqld]
bind-address = 10.0.0.11

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

##### 2.2.2.3. RabbitMQ Setup

```bash
server1 $ apt install rabbitmq-server 
server1 $ rabbitmqctl add_user openstack [password for rabbitmq]
server1 $ rabbitmqctl set_permissions openstack "." "." ".*"
```
- Ons password voor rabbitmq is 123

##### 2.2.2.4. Memcached Setup

```bash
server1 $ apt install memcached python3-pymemcache 
server1 $ vim /etc/memcached.conf
replace -l 127.0.0.1 with -l 10.0.0.11 
server1 $ service memcached restart
```

##### 2.2.2.5. Etcd Setup

```bash
server1 $ apt install etcd
server1 $ vim /etc/default/etcd
ETCD_NAME="server1"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01" ETCD_INITIAL_CLUSTER="server1=http://10.0.0.11:2380/" ETCD_INITIAL_ADVERTISE_PEER_URLS="http://10.0.0.11:2380/" ETCD_ADVERTISE_CLIENT_URLS="http://10.0.0.11:2379/" ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380/" 
ETCD_LISTEN_CLIENT_URLS="http://10.0.0.11:2379/" 
server1 $ systemctl enable etcd
server1 $ systemctl restart etcd
```

#### 2.2.3. Keystone

##### 2.2.3.1. Installatie

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

##### 2.2.3.2 Domain, projecten, gebruikers en rollen

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

#### 2.2.4. Glance

##### 2.2.4.1. Installatie

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
"[database]
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

Make sure that the glance account has reader access to system-scope resources:
server1 $ openstack role add --user glance --user-domain Default --system all reader

sync de database
server1 $ su -s /bin/sh -c "glance-manage db_sync" glance

server1 $ service glance-api restart
```

##### 2.2.4.2. Verify

- Verify glance using CirrOS, a small linux image that helps testing an openstack deployment

```bash
server1 $ . admin-openrc

server1 $ wget 'http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img'

upload the image to the image service, qcow2 format for qemu and visibility public zodat all projecten er aan kunnen:
server1 $ glance image-create --name "cirros" \
  --file cirros-0.4.0-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --visibility=public

controleer of de image ingeladen werd:
server1 $ glance image-list
```

#### 2.2.5. Placement

##### 2.2.5.1. Installatie

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

sync de database met de placement config
server1 $ su -s /bin/sh -c "placement-manage db sync" placement

server1 $ service apache2 restart
```

#### 2.2.6. Nova

##### 2.2.6.1. Installatie (controller node)

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

create nova user:
server1 $ openstack user create --domain default --password-prompt nova

add admin role to user:
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

"[api_database]
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
my_ip = 10.0.0.11

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

##### 2.2.6.2 Installatie (compute node)

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
my_ip = 10.0.0.12

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
password = 123"
```

```bash
check if node supports hardware accelleration
server2 $ egrep -c '(vmx|svm)' /proc/cpuinfo

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

#### 2.2.7. Neutron

##### 2.2.7.1. Installatie (controller node)

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

- We hebben gekozen voor self-service networks in plaats van Provider networks, dit bied ons veel meer flexibiliteit.

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

"[ovs]
bridge_mappings = provider:br-provider
local_ip = ens19

ovs-vsctl add-br br-provider
ovs-vsctl add-port br-provider ens18

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

"[DEFAULT]
nova_metadata_host = controller
metadata_proxy_shared_secret = 123"

Configure the Compute service to use the Networking service:

server1 $ vim /etc/nova/nova.conf

"[neutron]
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

##### 2.2.7.2. Installatie (compute node)

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
local_ip = ens19

ovs-vsctl add-br br-provider
ovs-vsctl add-port br-provider ens18

[agent]
tunnel_types = vxlan
l2_population = true

[securitygroup]
enable_security_group = true
firewall_driver = openvswitch
#firewall_driver = iptables_hybrid"

Configure the Compute service to use the Networking service:
server2 $ vim /etc/nova/nova.conf file

"[neutron]
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

#### 2.2.8. Horizon

##### 2.2.8.1. Installatie

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

### 2.3. Conclusie

In dit verslag hebben we een basis OpenStack-installatie opgezet met alleen de essentiële componenten. We hebben de volgende services geïnstalleerd: Keystone, Glance, Placement, Nova, Neutron en Horizon. Deze services vormen de kernfunctionaliteit voor het beheren van virtuele infrastructuur. We hebben de installatie en configuratie van elke service gedetailleerd beschreven, inclusief de benodigde stappen en configuratiebestanden. Door deze stappen te volgen, kunnen gebruikers een OpenStack-omgeving opzetten en beheren voor het uitvoeren van virtuele machines en het beheren van netwerkconnectiviteit. OpenStack biedt een krachtige en flexibele cloudoplossing die kan worden aangepast aan de behoeften van verschillende organisaties. Met de juiste configuratie en beheer kunnen gebruikers profiteren van de voordelen van cloud computing, zoals schaalbaarheid, flexibiliteit en kostenefficiëntie.

### 2.4. External references

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