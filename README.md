Ansible Automation for AKS on Azure Stack HCI
==============
Overview
-----------
This repository can be used to deploy AKS HCI Workload cluster via ansible automation.  The [scripts](Pipelines/playbooks/files) used in the automation have been created are based on the [steps here.](https://github.com/Azure/aks-hci/blob/main/eval/steps/1_AKSHCI_Azure.md)

Contents
-----------
- [Overview](#overview)
- [Contents](#contents)
- [Install Dependencies](#install-dependencies)
- [Configure Runtime](#configure-runtime)
- [Usage](#usage)
- [Notes](#notes)
- [References](#references)

Install Dependencies
-----------
First install the python dependencies via pip.  
`pip3 install -r requirements.txt  --user`

Next install the ansible collections defined in requirements.yml with the command below.  
`ansible-galaxy collection install -r requirements.yml`


Configure Runtime
-----------

Edit [Pipelines/playbooks/vars/required_vars.yml](Pipelines/playbooks/vars/required_vars.yml) and set varialbes pertaining to Azure HCI environment.  See file for more details.  
Edit [Pipelines/playbooks/vars/manage_aks_clusters_vars.yml](Pipelines/playbooks/vars/manage_aks_clusters_vars.yml) and set variables pertaining to clusters to be managed.   


The example below
- creates testarchciakscluster1 AKS workload cluster with 2 nodes in a linux node pool
- creates testarchciakscluster2 AKS workload cluster with 1 node in a windows node pool
- creates testarchciakscluster3 AKS workload cluster with 1 node in a windows node pool
```
aks_clusters:
  - clusterName: testarchciakscluster1
    state: present  #present indicates to the ansible code to create or update an aks hci cluster
    nodeCount: 2
    osType: 'Linux'
  - clusterName: testarchciakscluster2
    state: present 
    nodeCount: 1
    osType: 'Windows'
  - clusterName: testarchciakscluster3
    state: present 
    nodeCount: 1
    osType: 'Windows'
```

The example below 
- updates testarchciakscluster1 AKS workload cluster by removing a node
- updates testarchciakscluster2 AKS workload cluster by adding a node
- deletes testarchciakscluster3 AKS workload cluster
  
```
aks_clusters:
  - clusterName: testarchciakscluster1
    state: present  #present indicates to the ansible code to create or update an aks hci cluster
    nodeCount: 1
    osType: 'Linux'
  - clusterName: testarchciakscluster2
    state: present 
    nodeCount: 2
    osType: 'Windows'
  - clusterName: testarchciakscluster3
    state: absent #absent indicates that the cluster should be removed
    nodeCount: 1
    osType: 'Windows'
```

Configure environment variables for Azure authentication and place them on disk where they can be sourced 
- SUBSCRIPTION_ID
- APP_ID
- CLIENT_SECRET
- TENANT_ID

Example file contents testcreds.sh  
```
export SUBSCRIPTION_ID='<sub_id>'  
export APP_ID='<app_id>'  
export CLIENT_SECRET='<client_secret>'  
export TENANT_ID='<tenant_id>'
```
Prior to running ansible-playbook source that file via 
'. testcreds.sh'  

The credentials to the azure aks hci node should be added to the [az_inventory.yml](az_inventory.yml) file.  There is a second example file, [az_inventory_vault_example.yml](az_inventory_vault_example.yml), that contains credentials encrypted via ansible-vault.  For more security please encrypt with [ansible-vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html)  


Usage
-----------
Testing authentication
```
ansible -i az_inventory.yml hcimgmt_server -m win_ping
```
Test creating clusters defined in [Pipelines/playbooks/vars/manage_aks_clusters_vars.yml](Pipelines/playbooks/vars/manage_aks_clusters_vars.yml).
```
ansible-playbook -i az_inventory.yml Pipelines/playbooks/manage_aks_clusters.yml
```
if you are using ansible-vault to encrypt ansible variables the command below can be used along with the vault-password file.  The contents of .vault_password file will have the value that was used to encrypt the vault variables.
```
ansible-playbook -i az_inventory_vault_example.yml Pipelines/playbooks/manage_aks_clusters.yml --vault-password-file ~/.vault_password
```

Notes
-----------
The user that installed the aks hci software is bound to it for administration unless you [setup another admin user](https://docs.microsoft.com/en-us/azure-stack/aks-hci/set-multiple-administrators).  Advise the installer to use a service account instead of an individual user to avoid having the installation bound to individuals.  These commands should be run on the cluster owner which can be determined by the command below from an aks hci node.  This is not necessary in a test single node cluster.

```
Get-ClusterResource ca* | select name, OwnerNode
```

References
-----------
- [Azure Arc Jumpstart](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/aks_stack_hci/aks_hci_powershell/)
- [Evaluate AKS on Azure Stack HCI in Azure](https://github.com/Azure/aks-hci/blob/main/eval/steps/1_AKSHCI_Azure.md)

