$OUList = Get-ADOrganizationalUnit -Filter * -Properties Name,DistinguishedName | Select-Object -Property Name,DistinguishedName

$OU = $OUList | Out-GridView -Title "Select OU and Click OK" -OutputMode Single
$ADUserFilter = "*"

$ADUsers = Get-ADUser -SearchBase $OU.DistinguishedName -Filter $ADUserFilter -Properties LastLogOnDate | Select-Object -Property Name,Enabled,LastLogOnDate

$OU.DistinguishedName
Write-Host "------------"
$ADUsers
Clear-Variable ADuser
