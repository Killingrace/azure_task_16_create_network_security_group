$location = "polandcentral"
$resourceGroupName = "mate-azure-task-16"

$virtualNetworkName = "todoapp"
$vnetAddressPrefix = "10.20.30.0/24"
$webSubnetName = "webservers"
$webSubnetIpRange = "10.20.30.0/26"
$dbSubnetName = "database"
$dbSubnetIpRange = "10.20.30.64/26"
$mngSubnetName = "management"
$mngSubnetIpRange = "10.20.30.128/26"

$webnsgname = "nsg-" + $webSubnetName
$mngnsgname = "nsg" + $mngSubnetName
$dbnsgname = "nsg-" + $dbSubnetName

$webnsgrulenameHTTP = "HTTP"
$mngnsgrulenameSSH = "SSH"

Write-Host "Creating a resource group $resourceGroupName ..."
New-AzResourceGroup -Name $resourceGroupName -Location $location

Write-Host "Creating web network security group..."
# Write your code for creation of Web NSG here -> 

Write-Host "Creating mngSubnet network security group..."
# Write your code for creation of management NSG here -> 

Write-Host "Creating dbSubnet network security group..."
# Write your code for creation of management NSG here -> 

# NETWORK RULES
$webnsgruleHTTP = New-AzNetworkSecurityRuleConfig -Name $webnsgrulenameHTTP -Access Allow -Protocol Tcp -Direction Inbound -Priority 110 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80, 443
$mngnsgruleSSH = New-AzNetworkSecurityRuleConfig -Name $mngnsgrulenameSSH -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22

# NETWORK SECURITY GROUPS
$webnsg = New-AzNetworkSecurityGroup -Name $webnsgname -ResourceGroupName $resourceGroupName -Location $location -SecurityRules $webnsgruleHTTP
$mngnsg = New-AzNetworkSecurityGroup -Name $mngnsgname -ResourceGroupName $resourceGroupName -Location $location -SecurityRules $mngnsgruleSSH
$dbnsg = New-AzNetworkSecurityGroup -Name $dbnsgname -ResourceGroupName $resourceGroupName -Location $location

Write-Host "Creating a virtual network ..."
$webSubnet = New-AzVirtualNetworkSubnetConfig -Name $webSubnetName -AddressPrefix $webSubnetIpRange -NetworkSecurityGroup $webnsg
$dbSubnet = New-AzVirtualNetworkSubnetConfig -Name $dbSubnetName -AddressPrefix $dbSubnetIpRange -NetworkSecurityGroup $dbnsg
$mngSubnet = New-AzVirtualNetworkSubnetConfig -Name $mngSubnetName -AddressPrefix $mngSubnetIpRange -NetworkSecurityGroup $mngnsg
New-AzVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix $vnetAddressPrefix -Subnet $webSubnet,$dbSubnet,$mngSubnet