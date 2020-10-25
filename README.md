# ansible
Ansible

Deploy_authorized_key
---------------------

Adds our public key across all nodes on our ansible infraestructure 

files: 
deploy_authorized:key.yml  <- ansible magic
/root/.ssh/id_pub.rsa      <- our public key  
hosts                      <- hosts files (optional) 

Sintax: 

```
ansible-playbook -i hosts deploy_autorized_key.yml --ask-pass --extra-vars='pubkey="/root/.ssh/id_rsa.pub"'
```


