# PowerShell script to deploy an AKS cluster on HCI

#Environment variables to set up your AKS on HCI cluster
. ./aks_variables.ps1

$passwordsecure = ConvertTo-SecureString $password -AsPlainText -Force
$pscredential = New-Object -TypeName System.Management.Automation.PSCredential($appId, $passwordsecure)
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenant

Select-AzSubscription -SubscriptionId $subscriptionId

# Create a new cluster
Remove-AksHciCluster -name $clusterName
