# ansible
ansible 

pre_ansible 
-----------

Add mininum python requirements to give ansible support on hosts 

Tested on: 
- Debian 10
- Centos 7/8 

Sintax: 

```
ansible-playbook [-i hosts] pre_ansible.yml [--ask-pass]
```

Deploy_authorized_key
---------------------

Adds our public key across all nodes on our ansible infraestructure 

files: 
- deploy_authorized_key.yml  <- ansible magic
- root/.ssh/id_pub.rsa      <- our public key  
- hosts                      <- hosts files (optional) 

Sintax: 

```
ansible-playbook [-i hosts] deploy_autorized_key.yml --ask-pass --extra-vars='pubkey="/root/.ssh/id_rsa.pub"'
```

add-sudoer  
-----------

Prompts for a user and password that will be added to targets a adds them to sudoers without being able to user 'su' command 

Testest on: 
- Centos 7 

Sintax: 

```
ansible-playbook [-i hosts] add-sudoer.yml 
```

docker_master role
------------------

Deploys Docker, NFS Server and necessary files to create docker master nodes

Tested on:
- Debian 10
- Centos 7/8


Prompts for NFS network 


```
ansible-playbook [-i hosts] docker-master.yml
```


deploy-OCI.yml
---------------
Playbook for initital configuration on Oracle Cloud Infraestructure instances 

Actions performed: 
- Updates sources
- Installs minimal software (cron,jq,bind9-host,mailutils,etc...)
- Uploads Cloudflare update script 
- Creates a update task for Cloudflare update script 
- Uploads Firewall iptables update scripts
- Creates a update task for firewall update (vpn dynamic access) 
- Creates own administrative user and configures ssh access with pki 
- Deletes default ubuntu user on OCI instances 
- Install some CLI visuals (zsh, ohmysh, p10k,...) 

Variables needed:

cloudflare_api_key          
zone      
cloudflare_auth_email
notify_address
cloudflare_dns_name
new_username
new_password

Generate them with:

ansible-vault encrypt_string variable_password --name variable_name

Then store them on playbook_deploy_OCI_vars.yml template 

DON'T FORGET TO STORE YOUR PUBLIC KEY ON files/id_rsa.pub ! 

Usage: 

1st time (comma is needed!) 

ansible-playbook deploy_OCI.yml -i your_OCI_instance_public_IP, -u ubuntu --ask-vault-pass 

Next times 

ansible-playbook deploy_OCI.yml -i your OCI instance public IP, -u your-new-username --ask-vault-pass --ask-become-pass


deploy_docker.yml 
------------------
Installs docker on ubuntu 22.04 (ampere/amd micro) instances

Usage: 

ansible-playbook deploy_docker.yml -i your OCI instance -u your-admin-user --ask-become-pass 


