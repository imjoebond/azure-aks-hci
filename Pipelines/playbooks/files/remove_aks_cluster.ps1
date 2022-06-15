# PowerShell script to deploy an AKS cluster on HCI

#Environment variables to set up your AKS on HCI cluster
. ./remove_cluster_variables.ps1

$passwordsecure = ConvertTo-SecureString $password -AsPlainText -Force
$pscredential = New-Object -TypeName System.Management.Automation.PSCredential($appId, $passwordsecure)
echo "connecting to azure account with appID: $appId"
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenant
echo "connected to azure account with appID: $appId"

echo "selecting subscription $subscriptionId"
Select-AzSubscription -SubscriptionId $subscriptionId
echo "selected subscription $subscriptionId"

#remove arc connection for cluster
echo "removing arc connection for cluster Name: $clusterName"
Disable-AksHciArcConnection -Name $clusterName
echo "removed arc connection for cluster Name: $clusterName"

# remove cluster
echo "removing cluster Name: $clusterName"
Remove-AksHciCluster -name $clusterName -Confirm:$false
echo "removed cluster Name: $clusterName"