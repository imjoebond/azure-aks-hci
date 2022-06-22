# PowerShell script to deploy an AKS cluster on HCI

#Environment variables to set up your AKS on HCI cluster
. ./modify_cluster_variables.ps1


$passwordsecure = ConvertTo-SecureString $password -AsPlainText -Force
$pscredential = New-Object -TypeName System.Management.Automation.PSCredential($appId, $passwordsecure)
echo "connecting to azure account with appID: $appId"
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenant
echo "connected to azure account with appID: $appId"

echo "selecting subscription $subscriptionId"
Select-AzSubscription -SubscriptionId $subscriptionId
echo "selected subscription $subscriptionId"


# Update cluster
echo "updating cluster Name: $clusterName controlPlaneNodeCount: $controlPlaneNodeCount "
Set-AksHciCluster -name $clusterName -controlPlaneNodeCount $controlPlaneNodeCount
echo "updated cluster Name: $clusterName nodePoolName: $nodePoolName nodeCount: $nodeCount osType: $osType"

echo "updating nodePool for cluster Name: $clusterName nodepool nodePoolName: $nodePoolName nodeCount: $nodeCount"
Set-AksHciNodePool -clusterName $clusterName -name $nodePoolName -count $nodeCount
echo "updated nodePool for cluster Name: $clusterName nodepool nodePoolName: $nodePoolName nodeCount: $nodeCount"

echo "getting akshci credentials for clusterName: $clusterName"
Get-AksHciCredential -Name $clusterName -Confirm:$false
echo "retrieved akshci credentials for clusterName: $clusterName"

