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


# Create a new cluster
echo "creating new cluster Name: $clusterName controlPlaneNodeCount: $controlPlaneNodeCount nodePoolName: $nodePoolName nodeCount: $nodeCount osType: $osType kubernetesVersion: $kubernetesVersion"
New-AksHciCluster -name $clusterName -controlPlaneNodeCount $controlPlaneNodeCount -nodePoolName $nodePoolName -nodeCount $nodeCount -osType $osType -kubernetesVersion $kubernetesVersion
echo "created new cluster Name: $clusterName nodePoolName: $nodePoolName nodeCount: $nodeCount osType: $osType"

echo "getting akshci credentials for clusterName: $clusterName"
Get-AksHciCredential -Name $clusterName -Confirm:$false
echo "retrieved akshci credentials for clusterName: $clusterName"

if ( $arcEnabled ) #disabling speeds up testing time
{
# Arc onboarding 
echo "onboarding clusterName: $clusterName to akshciarc"
Enable-AksHciArcConnection -Name $clusterName -resourcegroup $resourceGroup -location $location -subscriptionid $subscriptionId -credential $pscredential -tenantId $tenant 
echo "onboarded clusterName: $clusterName to akshciarc"
}