#The first step
#Install-Module VMware.PowerCLI -Scope CurrentUser

#Create the local credential for login
#New-VICredentialStoreItem -Host vcenter-server.bryan86.hu -User -Password

#Ignore Invalid SSL Certification
#Set-PowerCLIConfiguration -InvalidCertificateAction Ignore

#Connect
#Connect-VIServer -Server vcenter-server.bryan86.hu -Port 444 -User

$server = "vcenter-server.bryan86.hu"
$user = "administrator@bryan.local"

function VIServer_login($server,$user,$port) {
    Connect-VIServer -Server $server -Port 444 -User $user
}

VIServer_login($server,$user)

#Test command
Get-VMHost