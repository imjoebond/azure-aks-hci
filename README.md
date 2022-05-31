# azure-aks-hci
A lot of this is borrowed from [Azure Arc Jumpstart](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/aks_stack_hci/aks_hci_powershell/)

##Install Dependencies
`pip3 install -r requirements.txt  --user`
`ansible-galaxy collection install -r requirements.yml`

edit [vars/cluster_vars.yml](vars/cluster_vars.yml)

##Configure AKS on the node
`ansible-playbook -i az_inventory.yml Pipelines/playbooks/config_aks_hci.yml`

##Create an AKS cluster
`ansible-playbook -i az_inventory.yml Pipelines/playbooks/create_aks_cluster.yml`
##Destroy an AKS cluster
`ansible-playbook -i az_inventory.yml Pipelines/playbooks/remove_aks_cluster.yml`
