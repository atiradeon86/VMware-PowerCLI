#For testing you must have a running vSphere server and VMware.PowerCLI Powershell Module

#Connect
#.\viconnect.ps1

#This script find all available Vm in vSphere Cluster and give related infos (with datastore) + performs a network connection test if you want
function GetComplexVMInfo($ping) {

$vmList = Get-VM
$vmDatas = @()

    foreach ($vm in $vmList)
    {   
        $ip = $vm.Guest.IPAddress[0]
        if ($ping -ne $null) {
            if ($vm.PowerState -match "PoweredOn") {
                $TestNetconnection = Test-NetConnection $ip
                $ping = $TestNetconnection.PingSucceeded
            } else {
                $ping = "Device is powered Off"
            }
        }
        $name = $vm.Name
        $UsedSpace = [math]::Round($vm.UsedSpaceGB)
        $vmObject = Get-Vm -Name $name
        $DsObject = Get-Datastore -RelatedObject $vmObject
        $Ds = $DsObject.Name
        $ip = $vm.Guest.IPAddress[0]
        $vmData = [PSCustomObject]@{
        Name = $name
        Hostname = $vm.Guest.HostName
        IPv4 = $ip
        ESXiHost = $vm.VMHost.Name
        PowerState = $vm.PowerState
        MaxMemory = $vm.MemoryGB
        UsedSpace =  $UsedSpace
        OS = $vm.Guest.OSFullName
        Datastore = $ds
    }
    $vmDatas += $vmData 
        if ($ping-ne $null) {
            $vmData.psobject.Properties.Add([PSNoteProperty]::new("Ping", "$ping"))
        }
    }
return  $vmDatas | Sort-Object -Property Datastore | Format-Table 
}

#Test without ping
#GetComplexVMInfo

#Test with ping
GetComplexVMInfo(1)