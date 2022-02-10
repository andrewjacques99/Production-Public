Get-PSSession | Remove-PSSession

$VSphereServerImport = Import-Csv -Path "C:\Powershell Scripts\CSV\VMServers.csv"

# Import Modue vmware viautomation core 
Import-Module vmware.vimautomation.core

Connect-VIServer $VSphereServerImport.Server
$SnapShotList = Get-VM | Get-SnapShot | Select Created, VM, Name, Description, SizeGB
$SnapShotCount = $SnapShotList | Measure
Write-Host "Snapshot Count = " $SnapShotCount.count
#$SnapShotListOutput = $VSphereServerImport, $SnapShotList
$SnapShotList | Sort-Object -Property VM | Out-GridView -Title "VMWare Snapshot List"


# Clears the Variables, this stops any issue with the variables bring back any previous held information
Remove-Variable * -ErrorAction SilentlyContinue
