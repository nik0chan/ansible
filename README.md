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


# NOTES 

Deploying instances on Google Cloud Platfom 

It's preferable to add public key on "Metadata -> SSH Keys" of your Google Cloud Plattofm to avoid password prompt in favour 
of  automatization 

Due to ssh daemon configuration on CentOS to connect remotely it's necessary to add the next lines on 
"Administration, security, disc, networks, owner" > Init command Sequence " during instance creation.  

sed -i 's/PermitRootLogin no/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config && service sshd reload  

